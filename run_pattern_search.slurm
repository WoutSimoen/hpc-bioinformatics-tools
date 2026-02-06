#!/bin/bash

# ==============================================================================
# SLURM Script: HMMER Pattern Search Workflow
# Description: Automates HMM profile building and sequence searching on HPC
# Usage: sbatch run_pattern_search.slurm <alignment.fasta> <test_sequences.fasta>
# ==============================================================================

# --- SLURM Resource Allocation ---
#SBATCH --job-name=hmmer_search
#SBATCH --output=hmmer_%j.out
#SBATCH --error=hmmer_%j.err 

#SBATCH --partition=batch
#SBATCH --cpus-per-task=1
#SBATCH --time=0:10:00
#SBATCH --mem=2G
#SBATCH --clusters=wice

# Uncomment and update the lines below for email notifications
##SBATCH --mail-type=BEGIN,END,FAIL
##SBATCH --mail-user=your.email@example.com

# --- Argument Validation ---
if [ "$#" -ne 2 ]; then
    echo "Error: Missing arguments."
    echo "Usage: sbatch $0 <training_alignment.fasta> <test_sequences.fasta>"
    exit 1
fi

# --- Environment Setup ---
# Purging and loading cluster-specific modules for HMMER compatibility
module purge
module load cluster/wice/batch
module load HMMER

# --- Variable Definitions ---
ALIGNMENT=$1
TEST=$2
MODEL=profile_model.hmm
RESULTS=search_results.txt

# --- Logging Job Metadata ---
START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
echo "Job started: $START_TIME"
echo "Working directory: $(pwd)"
echo "Building HMM from: $ALIGNMENT"
echo "Test sequences: $TEST"

# --- Data Staging ---
# Moving data to high-performance scratch storage ($VSC_DATA)
echo "Staging data to $VSC_DATA"
cp "$ALIGNMENT" "$VSC_DATA/"
cp "$TEST" "$VSC_DATA/"
cd "$VSC_DATA" || exit

# --- Core Workflow ---
# 1. Build HMM profile from training alignment
echo "Execution: hmmbuild"
hmmbuild "$MODEL" "$(basename "$ALIGNMENT")"

# 2. Search test sequences using the generated profile
echo "Execution: hmmsearch"
hmmsearch --tblout "$RESULTS" "$MODEL" "$(basename "$TEST")"

# 3. Summary of results
grep -v "^#" "$RESULTS" | wc -l > hit_count.txt
echo "Summary: Number of hits saved to hit_count.txt"

# --- Cleanup and Data Export ---
# Moving final results back to persistent storage ($VSC_HOME)
echo "Exporting results to $VSC_HOME"
mv "$RESULTS" "$VSC_HOME/"

echo "Job completed: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Final results available at $VSC_HOME/$RESULTS"