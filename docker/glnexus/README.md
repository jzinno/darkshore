# GLnexus Docker Container

## Description
Docker container for GLnexus, a scalable joint variant calling tool for population-scale genomics that merges single-sample gVCF files into multi-sample VCF files with sophisticated variant normalization.

## Base Image
- **Base**: Multi-stage build from `ubuntu:18.04` (builder) to `ubuntu:20.04` (runtime)
- **GLnexus**: Custom build from forked repository
- **Source**: Forked from [DNAnexus R&D GLnexus](https://github.com/dnanexus-rnd/GLnexus)

## Tools Included
- **GLnexus**: Scalable joint variant calling from gVCF files
- **bcftools**: VCF/BCF file manipulation utilities
- **tabix**: Generic indexer for genomic coordinate files
- **spVCF**: Sparse VCF format utilities
- **pv**: Progress viewer for data transfer
- **jemalloc**: Memory allocator for performance optimization

## Usage
This container is used by joint genotyping workflows to merge single-sample gVCF files:

```bash
# Example usage in Nextflow
container 'docker://zinno/glnexus:latest'
```

## Build
```bash
docker build -t zinno/glnexus:latest .
```

## Key Features
- Multi-stage build for optimized container size
- Statically linked GLnexus executable for portability
- Pre-loaded with jemalloc for memory efficiency
- Multi-threaded bgzip with libdeflate support
- Built-in VCF validation and compression tools
- Compatible with darkshore joint calling workflows

## GLnexus Capabilities
- Joint calling from DeepVariant gVCF files
- Sophisticated variant normalization and filtering
- Scalable to thousands of samples
- Configurable quality score recalibration
- Memory-efficient streaming processing
