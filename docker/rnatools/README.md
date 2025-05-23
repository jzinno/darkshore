# rnatools Docker Container

## Description
Comprehensive Docker container for RNA-seq analysis containing essential tools for quality control, alignment, quantification, and reporting.

## Base Image
- **Base**: `python:3.10.14-slim-bullseye`
- **Python version**: 3.10.14

## Tools Included

### Alignment & Preprocessing
- **STAR 2.7.1a**: Spliced alignment for RNA-seq
- **fastp 0.24.0**: Ultra-fast FASTQ preprocessor
- **samtools**: SAM/BAM file manipulation

### Quantification & Analysis
- **HTSeq**: Gene expression quantification
- **MultiQC**: Quality control report aggregation

### System Tools
- **procps**: Process utilities
- **bash**: Shell environment

## Usage
This container is used by multiple RNA-seq workflow processes:
- `FastP` process for quality trimming
- `Star` process for read alignment  
- `HTSeq` process for gene counting
- `RNAMultiQC` process for QC reporting

```bash
# Example usage in Nextflow
container 'docker://zinno/rnatools:latest'
```

## Build
```bash
docker build -t zinno/rnatools:latest .
```

## Key Features
- Optimized for single-cell RNA-seq workflows
- Minimal footprint with cleaned package cache
- Static STAR binary for consistent performance
- Compatible with darkshore Nextflow pipelines