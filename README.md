# HPC Bioinformatics Workflows

This repository contains optimized job scripts for executing large-scale bioinformatics tools on High-Performance Computing (HPC) environments. The focus is on automated scheduling, resource management, and efficient data staging.

### HMMER Pattern Search Workflow
[cite_start]The primary script, `run_pattern_search.slurm`, automates HMM profile building and sequence searching[cite: 1].

**Key Features**
- [cite_start]**Data Staging:** Implements transfer between persistent storage ($VSC_HOME) and high-performance scratch storage ($VSC_DATA)[cite: 1].
- [cite_start]**Input Validation:** Verifies user arguments before job submission to prevent runtime errors[cite: 1].
- [cite_start]**Environment Management:** Handles automated module purging and cluster-specific loading for the Wice cluster[cite: 1].
- [cite_start]**Workflow Logging:** Provides job metadata including start times, account tracking, and hit counts[cite: 1].

### Usage
To run the pattern search workflow on a Slurm-compatible cluster:
```bash
sbatch run_pattern_search.slurm <training_alignment.fasta> <test_sequences.fasta>
