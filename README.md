# KAPT
Inference of the Kappaphycus alvarezii pan-transcriptome

![](https://github.com/felipevzps/KAPT/blob/main/images/pipeline.svg)

---

# requirements

Ensure the following tools are installed before running the pipeline:

- `Nextflow` (version **24.10.2**)
- `Conda`

---

# setup

1. Clone this repository:

```bash
# clone
git clone https://github.com/felipevzps/KAPT.git
```

2. Create and activate our conda environment:

```bash
# creating conda environment
conda env create -n KAPT -f environment.yml

# activating environment
conda activate KAPT
```

---

# how to run

From the project root directory, execute:

```bash
# run the pipeline
nextflow run workflows/KAPT.nf -c config/nextflow.config
```

---

# questions?

For suggestions, bug reports, or collaboration, feel free to open an [issue](https://github.com/felipevzps/KAPT/issues).
