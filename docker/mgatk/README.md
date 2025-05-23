# mgatk Docker Container

## Description
Custom Docker container for mitochondrial genome analysis toolkit (mgatk) with additional dependencies for single-cell mitochondrial variant calling.

## Base Image
- **Base**: `quay.io/biocontainers/mgatk:0.7.0--pyhdfd78af_1`
- **mgatk version**: 0.7.0

## Additional Dependencies
- `ruamel.yaml<0.18.0` - YAML processing library for configuration parsing

## Usage
This container is used by the `MitoCall` process in `modules/mgatk/main.nf` for mitochondrial variant calling from single-cell BAM files.

```bash
# Example usage in Nextflow
container 'docker://zinno/mgatk:latest'
```

## Build
```bash
docker build -t zinno/mgatk:latest .
```

## Tools Included
- **mgatk**: Mitochondrial genome analysis toolkit for single-cell data
- **Python 3**: With scientific computing libraries
- **samtools**: For BAM file processing