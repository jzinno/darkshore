# GATK Docker Container

## Description
Pre-built Docker container from the Broad Institute containing the Genome Analysis Toolkit (GATK) for variant discovery in high-throughput sequencing data.

## Base Image
- **Base**: `broadinstitute/gatk:4.5.0.0`
- **GATK version**: 4.5.0.0
- **Source**: [Broad Institute GATK Docker Hub](https://hub.docker.com/r/broadinstitute/gatk/)

## Tools Used in Darkshore
- **MarkDuplicates**: Duplicate read marking with flow mode support
- **GetPileupSummaries**: Pileup summary generation for contamination estimation
- **CalculateContamination**: Cross-contamination calculation for quality control

## Usage
This container is used in darkshore workflows for BAM preprocessing and quality control:

```bash
# Example usage in Nextflow
container 'docker://broadinstitute/gatk:4.5.0.0'
```

## Build
Official Broad Institute container - no custom build required.

## Key Features
- Official Broad Institute maintained container
- Flow mode support for Oxford Nanopore data in MarkDuplicates
- Contamination estimation capabilities
- Java runtime optimized for large-scale genomics
- Compatible with darkshore preprocessing workflows

## Workflow Integration
Used in darkshore workflows for:
- **Deduplication**: Removing PCR duplicates before variant calling
- **Quality Control**: Estimating cross-sample contamination
- **Preprocessing**: Preparing BAM files for downstream variant calling
