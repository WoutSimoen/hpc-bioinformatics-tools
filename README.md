# HPC Bioinformatics Workflows

This repository contains optimized job scripts for executing large-scale bioinformatics tools on High-Performance Computing (HPC) environments. The focus is on automated scheduling, resource management, and efficient data staging.

### HMMER Pattern Search Workflow
The primary script, `run_pattern_search.slurm`, automates HMM profile building and sequence searching.

**Key Features**
- **Data Staging:** Implements transfer between persistent storage ($VSC_HOME) and high-performance scratch storage ($VSC_DATA).
- **Input Validation:** Verifies user arguments before job submission to prevent runtime errors.
- **Environment Management:** Handles automated module purging and cluster-specific loading for the Wice cluster.
- **Workflow Logging:** Provides job metadata including start times, account tracking, and hit counts.

### Usage
To run the pattern search workflow on a Slurm-compatible cluster:
```bash
sbatch run_pattern_search.slurm <training_alignment.fasta> <test_sequences.fasta>
