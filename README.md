# KAPT
[![Nextflow](https://img.shields.io/badge/workflow-nextflow-blue)](https://www.nextflow.io/) [![Status](https://img.shields.io/badge/status-active-success.svg)]() [![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)  

Automated inference of the Kappaphycus alvarezii pan-transcriptome through de novo assembly and comprehensive functional annotation.

---

# prerequisites

KAPT.nf requires Nextflow 23.04.4 or higher.  
>Follow [this tutorial](https://www.nextflow.io/docs/latest/install.html) to install Nextflow.

We use Conda to avoid dependency conflicts and ensure reproducible environments across different systems.  
Make sure you have installed Conda 4.12.0 or higher.
>Follow [this tutorial](https://www.anaconda.com/docs/getting-started/miniconda/install#linux) to install Miniconda, a miniature version of Anaconda.

---

# installing and configuring

Clone this repository to install KAPT.nf:

```bash
git clone https://github.com/felipevzps/KAPT.git
cd KAPT
```

---

KAPT.nf requires an input sample in CSV format containing the following information:    
- run: SRA Accession ID of RNA-seq data
- sample_name: Optional but recommended for readability  

See an example below:

```bash
cat samples/PRJNA971596_BHL.csv

run,sample_name
SRR24507659,Brown phenotype - High Light (BHL)
SRR24507661,Brown phenotype - High Light (BHL)
SRR24507678,Brown phenotype - High Light (BHL)
SRR24507679,Brown phenotype - High Light (BHL)
```

>[!TIP]
>This is [an example](https://github.com/felipevzps/KAPT/blob/main/samples/PRJNA971596_BHL.csv) of publicly available RNA-seq data from Kappaphycus alvarezii (brown phenotype) grown under high light conditions (910 mmol/m-2S-1 light).
>
>All samples used in this study are available in the [KAPT/samples/](https://github.com/felipevzps/KAPT/tree/main/samples) directory.

---

# database installation

KAPT.nf uses eggNOG-mapper for fast functional annotation of protein sequences.  
This approach provides comprehensive orthology-based annotation with COG, KEGG, and GO terms.  

Below is an example for downloading the eggNOG-mapper database:

```bash
eggnog_db_path="/path/to/eggnog_database/"
download_eggnog_data.py --data_dir $eggnog_db_path -y
```
>Follow [this tutorial](https://github.com/eggnogdb/eggnog-mapper/wiki/eggNOG-mapper-v2.1.5-to-v2.1.13#setup) for complete installation of the eggNOG-mapper database.

---

Since we are working with transcriptome assembly of red algae, we need the gene content of near-universal single-copy orthologs of Rhodophyta to assess assembly quality with BUSCO.  

Below is an example for downloading the Rhodophyta BUSCO database:

```bash
busco_db_path="/path/to/busco_downloads/"
busco --datasets_version odb12 --download rhodophyta_odb12 --download_path $busco_db_path
```

---

After downloading the databases, make sure to update the configuration file with your database paths.  

See an example below:

```
head config/nextflow.config
// config file for defining module parameters

params {
    // paths to databases 
    eggnog_db_path = "/path/to/eggnog_database"
    busco_db_path = "/path/to/busco_downloads/"
```

>[!TIP]
>This is the [configuration file](https://github.com/felipevzps/KAPT/blob/main/config/nextflow.config) used in this study.
---

# running the pipeline

From the pipeline root directory, execute:

```bash
cd KAPT

# example for running the pipeline inside a SGE HPC cluster 
nextflow run workflows/KAPT.nf -c config/nextflow.config -profile sge --samples_csv samples/PRJNA971596_BHL.csv --output_dir "../results/PRJNA971596_BHL" --report_dir "report/PRJNA971596_BHL"

# you can use the -resume flag to re-run the pipeline if some step failed
nextflow run workflows/KAPT.nf -c config/nextflow.config -resume -profile sge --samples_csv samples/PRJNA971596_BHL.csv --output_dir "../results/PRJNA971596_BHL" --report_dir "report/PRJNA971596_BHL"
```

---

# questions?

For suggestions, bug reports, or collaboration, feel free to open an [issue](https://github.com/felipevzps/KAPT/issues).
