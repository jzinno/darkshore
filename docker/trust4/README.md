# TRUST4 Docker Container

## Description
Docker container for TRUST4 (T cell Receptor Utilities for Solid Tissue/Tumor), a tool for TCR and BCR assembly from RNA-seq data.

## Base Image
- **Base**: `ubuntu:20.04`
- **TRUST4**: Latest version from GitHub repository

## Tools Included
- **TRUST4**: TCR/BCR reconstruction from RNA-seq data
- **Build tools**: gcc, make, perl for compilation
- **Development libraries**: zlib1g-dev for compression support

## Usage
This container is used by TCR analysis workflows for reconstructing T-cell and B-cell receptor sequences from single-cell RNA-seq data.

```bash
# Example usage in Nextflow
container 'docker://zinno/trust4:latest'
```

## Build
```bash
docker build -t zinno/trust4:latest .
```

## Key Features
- Fresh build of TRUST4 from source
- Optimized for single-cell TCR reconstruction
- Includes all necessary compilation dependencies
- Compatible with darkshore scRNA and scTCR workflows

## TRUST4 Capabilities
- TCR α/β chain reconstruction
- BCR heavy/light chain assembly
- Support for both paired-end and single-end reads
- Integration with standard RNA-seq workflows
- High sensitivity for low-expression immune receptors