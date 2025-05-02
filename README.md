# Bacterial Genome Assembly Workflow

This repository contains a modular Snakemake pipeline for long-read-based bacterial genome assembly and polishing. It uses tools such as Canu, BWA, Racon, and custom scripts for assembly statistics.

---

## 🧬 Dataset

You can download the PacBio long-read dataset used in this example with:

```bash
curl -L -o pacbio.fastq http://gembox.cbcb.umd.edu/mhap/raw/ecoli_p6_25x.filtered.fastq
```

Place the downloaded file in the `rawData/` directory.

---

## 📁 Folder Structure

```
.
├── config/           # YAML config files for each pipeline stage
│   ├── assembly.yaml
│   ├── annotation.yaml
│   └── polishing.yaml
├── envs/             # Conda environment YAMLs
├── rawData/          # Input FASTQ data (download or place here)
├── rules/            # Snakemake rule files (modular pipeline)
│   ├── annotation.smk
│   ├── assembly.smk
│   ├── correction.smk
│   ├── polishing.smk
│   └── trimming.smk
├── scripts/          # Custom helper scripts (e.g., stats)
│   └── contig-stats.pl
├── Snakefile         # Entry point that includes all modular rules
```

---

## 🛠️ Usage

1. **Setup conda environments** (if needed):

```bash
conda env create -f envs/assembly.yaml
```

2. **Run the pipeline**:

```bash
snakemake --use-conda --cores <number_of_threads>
```

3. **Clean up**:

```bash
snakemake clean
```

---

## 📝 License

This project is licensed under the [MIT License](LICENSE).

---

## 📫 Contact

For any issues, please open an [issue](https://github.com/chandan/bacterial-assembly/issues).

## Acknowledgments

This workflow makes use of the following bioinformatics tools:

- [Snakemake](https://snakemake.readthedocs.io/en/stable/) – Workflow management system
- [Canu](https://github.com/marbl/canu) – Long-read assembly
- [BWA](http://bio-bwa.sourceforge.net/) – Read alignment
- [SAMtools](http://www.htslib.org/) – Alignment manipulation
- [Racon](https://github.com/lbcb-sci/racon) – Consensus polishing
- [Pilon](https://github.com/broadinstitute/pilon) – Genome polishing (optional/future use)
- [BBTools (reformat.sh)](https://jgi.doe.gov/data-and-tools/bbtools/) – Assembly filtering

We thank the developers of these tools for their contributions to the scientific community.
