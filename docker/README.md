# List of tools used in the pipeline

## DNA tools

### GATK
[Broad's Genome Analysis Toolkit](https://gatk.broadinstitute.org/)
```
broadinstitute/gatk:4.5.0.0
```

### Parabricks

[NVIDIA Clara Parabricks](https://www.nvidia.com/en-us/clara/genomics/)

With some additional tools (bgzip and tabix)
```
zinno/parabricks:4.2.1-1b
```

### ugdv
[Ultima Genomics DeepVariant Implimentation](https://github.com/UltimaGenomics/deepvariant)
```
zinno/ugdv:latest
```

### GLnexus

[Joint Genotyping](https://github.com/dnanexus-rnd/GLnexus)
```
zinno/glnexus:latest
```

### Annovar

[Annotation Tooling](http://annovar.openbioinformatics.org/)
```
zinno/annovar:latest
```

### MGATK

[Mitochondrial Genotyping](https://caleblareau.github.io/mgatk/)
```
quay.io/biocontainers/mgatk:0.7.0--pyhdfd78af_1
```

### TRUST4

[T-cell Receptor and B-cell Receptor Analysis](https://github.com/liulab-dfci/TRUST4)
```
zinno/trust4:1.1.5
```

### BioUtils

Common bioinformatics tools (samtools, bcftools, bedops)
```
zinno/bioutils:latest
```
