#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// include modules
include { getReadFTP                    } from "../modules/getReadFTP.nf"
include { downloadReadFTP               } from "../modules/downloadReadFTP.nf"
include { fastqc as raw_fastqc          } from "../modules/fastqc.nf"
include { multiqc as raw_multiqc        } from "../modules/multiqc.nf"
include { bbduk                         } from "../modules/bbduk.nf"
include { fastqc as trimmed_fastqc      } from "../modules/fastqc.nf"
include { multiqc as trimmed_multiqc    } from "../modules/multiqc.nf"
include { trinity                       } from "../modules/trinity.nf"
include { salmonIndex                   } from "../modules/salmonIndex.nf"
include { salmonQuant                   } from "../modules/salmonQuant.nf"
include { busco                         } from "../modules/busco.nf"
include { transrate                     } from "../modules/transrate.nf"
include { transdecoder                  } from "../modules/transdecoder.nf"
include { eggNOG_mapper                 } from "../modules/eggNOG-mapper.nf"

workflow {
    // read csv with samples (run = SRA Accession ID)
    samples_ch = Channel.fromPath(params.samples_csv)
                        .splitCsv(header: true)

    // map run and sample_name (from samples.csv)
    sample_info = samples_ch.map{ row -> tuple(row.run, row.sample_name) }

    // get SRA Accession and set accession channel
    sample_info.map{ run, sample_name -> run } set { accession_ch }

    // ~~~~~~ WORKFLOW START ~~~~~~

    // run process getReadFTP
    json_ch = accession_ch | getReadFTP
    getReadFTP.out.view{ "getReadFTP: $it" }

    // download fastq files from getReadFTP 
    fastq_ch = json_ch | downloadReadFTP
    downloadReadFTP.out.view{ "downloadReadFTP: $it" }

    // run fastqc on raw data
    raw_fastqc_ch = fastq_ch | raw_fastqc
    raw_fastqc.out.view{ "raw_fastqc: $it" }

    // group only fastqc directories and run multiqc 
    raw_multiqc_ch = raw_fastqc_ch.map{ run, dir -> dir }.collect() | raw_multiqc
    raw_multiqc.out.view{ "raw_multiqc: $it" }

    // run bbduk 
    trimmed_fastq_ch = fastq_ch | bbduk
    bbduk.out.view{ "bbduk: $it" }

    // run fastqc on trimmed data 
    trimmed_fastqc_ch = trimmed_fastq_ch | trimmed_fastqc
    trimmed_fastqc.out.view{ "trimmed_fastqc: $it" }

    // group only fastqc directories and run multiqc 
    trimmed_multiqc_ch = trimmed_fastqc_ch.map{ run, dir -> dir }.collect() | trimmed_multiqc
    trimmed_multiqc.out.view{ "trimmed_multiqc: $it" }
    
    // perform de novo transcriptome assembly
    trinity_ch = trimmed_fastq_ch.map{ run, fastq_files -> fastq_files }.collect() | trinity
    trinity.out.view{ "trinity: $it" }

    // run salmonIndex on assembled transcriptome
    salmon_index_ch = trinity_ch | salmonIndex 
    salmonIndex.out.view{ "salmonIndex: $it" }
    
    // run salmonQuant on assembled transcriptome 
    salmon_quant_ch = trimmed_fastq_ch.combine(salmon_index_ch) | salmonQuant
    salmonQuant.out.view{ "salmonQuant: $it" }

    // evaluate completeness (find orthologs in rhodophyta_odb12 database)
    busco_ch = trinity_ch | busco 
    busco.out.view{ "busco: $it" }

    // evaluate transcriptome metrics
    transrate_ch = trinity_ch | transrate 

    // predict CDS and protein sequences
    transdecoder_ch = trinity_ch | transdecoder 
    transdecoder.out.view{ "transdecoder: $it" }

    // functional annotation of predicted proteins (eggNOG-mapper)
    eggnog_ch = transdecoder_ch | eggNOG_mapper
    eggNOG_mapper.out.view{ "eggNOG-mapper: $it" }
}
