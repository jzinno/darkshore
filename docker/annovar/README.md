# ANNOVAR Docker Container

## Description
Docker container for ANNOVAR (ANNOtate VARiation), a comprehensive tool for functional annotation of genetic variants detected from diverse genomes.

## Base Image
- **Base**: `ubuntu:latest`
- **ANNOVAR**: Latest version from OpenBioinformatics
- **Source**: Forked from [bioinfo-chru-strasbourg](https://github.com/bioinfo-chru-strasbourg/annovar)

## Tools Included
- **ANNOVAR**: Functional annotation of genetic variants
- **HTSLib 1.14**: High-throughput sequencing data processing
- **Perl**: Runtime environment for ANNOVAR scripts
- **bgzip/tabix**: For VCF compression and indexing

## Usage
This container is used by the annotation workflows for adding functional information to variants:

```bash
# Example usage in Nextflow
container 'docker://zinno/annovar:latest'
```

## Build
```bash
docker build -t zinno/annovar:latest .
```

## Key Features
- Pre-configured database linking for annotation databases
- Includes all ANNOVAR Perl scripts
- HTSLib integration for VCF processing
- Optimized for large-scale variant annotation
- Compatible with darkshore annotation workflows

## Database Configuration
The container expects annotation databases to be mounted at `/databases` and automatically links them to the ANNOVAR humandb directory.
