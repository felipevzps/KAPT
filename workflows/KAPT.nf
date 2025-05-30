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
include { MMSeqs2                       } from "../modules/mmseqs2.nf"
include { salmonIndex                   } from "../modules/salmonIndex.nf"
include { salmonQuant                   } from "../modules/salmonQuant.nf"
include { busco                         } from "../modules/busco.nf"
include { transrate                     } from "../modules/transrate.nf"
include { transdecoder                  } from "../modules/transdecoder.nf"
include { eggNOG-mapper                 } from "../modules/eggNOG-mapper.nf"

workflow {
    // read csv with samples (run = SRA Accession)
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
    
    // assembly transcriptome (trinity)

    // cluster non-redundant transcripts (MMSeqs2)

    // run salmonIndex on assembled transcriptome
    salmon_index_ch = salmonIndex(params.assembled_transcriptome) // TODO: declare assembled transcriptome
    salmonIndex.out.view{ "salmonIndex: $it" }
    
    // run salmonQuant on assembled transcriptome 
    salmon_quant_ch = trimmed_fastq_ch.combine(salmon_index_ch) | salmonQuant
    salmonQuant.out.view{ "salmonQuant: $it" }

    // evaluate completeness (busco)

    // evaluate transcriptome metrics (transrate)

    // predict CDS and protein sequences (transdecoder)

    // functional annotation of predicted proteins (eggNOG-mapper)
}
