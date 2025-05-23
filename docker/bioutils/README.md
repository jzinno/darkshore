# BioUtils Docker Container

## Description
Generic Ubuntu-based Docker container that includes essential bioinformatics command-line tools commonly used across darkshore workflows for file format conversion and manipulation.

## Base Image
- **Base**: `ubuntu:20.04`
- **Architecture**: x86_64 Linux

## Tools Included
- **samtools 1.18**: SAM/BAM/CRAM file manipulation and analysis
- **bcftools 1.18**: VCF/BCF file manipulation and variant calling utilities
- **bedops 2.4.41**: Genomic interval operations and BED file processing
- **tabix**: Generic indexer for TAB-delimited genome position files

## Usage
This container provides utility functions across multiple darkshore workflows:

```bash
# Example usage in Nextflow
container 'docker://zinno/bioutils:latest'
```

## Build
```bash
docker build -t zinno/bioutils:latest .
```

## Key Features
- Lightweight Ubuntu base with essential bioinformatics tools
- Static compilation for consistent performance
- All tools compiled from source for optimization
- Compatible with all darkshore workflow modules
- Minimal footprint with cleaned package cache

## Dependencies
All tools are built with necessary compression libraries:
- **zlib**: For gzip compression
- **libbz2**: For bzip2 compression  
- **liblzma**: For LZMA/XZ compression
- **libdeflate**: For optimized deflate compression
- **libcurl & libssl**: For remote file access
