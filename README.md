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

---

# how to run

From the project root directory, execute:

```bash
# run the pipeline
nextflow run workflows/KAPT.nf -c config/nextflow.config -resume -profile process_low,process_medium,process_high,sge --samples_csv samples/${bioproject}.csv --output_dir "../results/${bioproject}" --report_dir "report/${bioproject}"
```

---

# questions?

For suggestions, bug reports, or collaboration, feel free to open an [issue](https://github.com/felipevzps/KAPT/issues).
