# darkshore

[![Docker Build](https://github.com/jzinno/darkshore/actions/workflows/docker-build.yml/badge.svg)](https://github.com/jzinno/darkshore/actions/workflows/docker-build.yml)

### Nextflow pipelines for the worlds biggest single-cell multiomic phylogenies

## Quick start & Test run

```bash
   git clone https://github.com/jzinno/darkshore.git

   cd darkshore

   nextflow workflows/scVC.nf -stub-run -profile stub

   #explore example output
   tree -C output
```

## Installation

### Requirements

These workflows were developed using the following:

- Nextflow 22.10.4+
- Singularity 3.8.6+

The pipelines will automatically pull the required containers when run. Our reference data bundle is required in order to run the pipelines, in order to download the required files run:

```bash
   cd resources
   ./ref_setup.sh
```

More information on the reference data bundle can be found [here](https://github.com/jzinno/darkshore/tree/main/resources).

## Workflows Overview

### Variant Calling Workflows

#### `scVC.nf` - Single-cell variant calling from BAM files
Comprehensive variant calling pipeline for single-cell DNA sequencing data:

- Duplicate marking with Picard
- Contamination estimation 
- DeepVariant variant calling (GPU/CPU)
- GLNexus joint genotyping
- Variant annotation with Annovar

```bash
# Create BAM list file
# bam_list.txt
/path/to/cell1.bam
/path/to/cell2.bam
/path/to/cell3.bam

nextflow workflows/scVC.nf --bam_list bam_list.txt --sample_id my_sample
```

#### `scVC-il.nf` - Illumina variant calling from FASTQ files  
End-to-end pipeline starting from raw Illumina FASTQ files:

```bash
# Create FASTQ pairs file  
# fq_list.txt
/path/to/cell1_R1.fastq.gz /path/to/cell1_R2.fastq.gz
/path/to/cell2_R1.fastq.gz /path/to/cell2_R2.fastq.gz

nextflow workflows/scVC-il.nf --fq_list fq_list.txt --sample_id my_sample
```


### RNA-seq Workflows

#### `scRNA.nf` - Single-cell RNA-seq analysis
Complete RNA-seq processing pipeline:

- Quality control with FastP
- Alignment with STAR
- Gene quantification with HTSeq
- Optional TCR analysis with Trust4
- Count matrix generation
- Quality control reports with MultiQC

```bash
# Create RNA FASTQ pairs file
# rna_fastq_pairs.txt  
/path/to/cell1_R1.fastq.gz /path/to/cell1_R2.fastq.gz
/path/to/cell2_R1.fastq.gz /path/to/cell2_R2.fastq.gz

nextflow workflows/scRNA.nf --rna_fastq_table rna_fastq_pairs.txt --sample_id my_sample
```

#### `scTE.nf` - Transposable element analysis
Specialized pipeline for quantifying transposable element expression.

#### `scTCR.nf` - T-cell receptor analysis  
Dedicated TCR reconstruction and analysis using Trust4.

### Specialized Workflows

#### `Anno.nf` - Standalone variant annotation
Annotate existing VCF files without running variant calling:

```bash
nextflow workflows/Anno.nf --joint_vcf my_variants.vcf.gz --sample_id my_sample
```

#### `Joint.nf` - Joint genotyping
Perform joint genotyping on a collection of GVCF files:

```bash
# Create GVCF list file
# gvcf_list.txt
/path/to/sample1.g.vcf.gz
/path/to/sample2.g.vcf.gz

nextflow workflows/Joint.nf --gvcf_list gvcf_list.txt --sample_id cohort_name
```

#### `MitoCall.nf` - Mitochondrial variant calling
Specialized pipeline for mitochondrial genome variant detection.

## Configuration Parameters

### Input Parameters
| Parameter | Description | Required | Default |
|-----------|-------------|----------|---------|
| `bam_list` | Path to file containing BAM file paths (one per line) | scVC.nf | `"bams.txt"` |
| `fq_list` | Path to file containing FASTQ pair paths (space-separated R1/R2 per line) | scVC-il.nf | `"fq_list.txt"` |
| `rna_fastq_table` | Path to file containing RNA FASTQ pair paths | scRNA.nf | `"rna_test.txt"` |
| `gvcf_list` | Path to file containing GVCF file paths (one per line) | Joint.nf | `"gvcf_list.txt"` |
| `joint_vcf` | Path to input VCF file for annotation | Anno.nf | `"test.vcf.gz"` |
| `sample_id` | Sample identifier for output naming | All | `"test"` |

### Output Parameters  
| Parameter | Description | Default |
|-----------|-------------|---------|
| `out` | Output directory path | `"output"` |

### Reference Data Parameters
| Parameter | Description | Default |
|-----------|-------------|---------|
| `resource_dir` | Base directory for reference data | `$ref_bundle` |
| `ref` | Reference genome FASTA file | `"${resource_dir}/hg38/v0/Homo_sapiens_assembly38.fasta"` |
| `ref_idx` | Reference genome index file | `"${resource_dir}/hg38/v0/Homo_sapiens_assembly38.fasta.fai"` |
| `star_ref` | STAR genome index directory | `"${resource_dir}/refdata-gex-GRCh38-2024-A/star/"` |
| `gtf` | Gene annotation GTF file | `"${resource_dir}/refdata-gex-GRCh38-2024-A/genes/genes.gtf"` |
| `te_gtf` | Transposable element GTF file | `"${resource_dir}/TE/GRCh38_GENCODE_rmsk_TE.gtf"` |
| `trust4_vdjc` | Trust4 V(D)J and C gene sequences | `"${resource_dir}/TRUST4/hg38_bcrtcr.fa"` |
| `trust4_ref` | Trust4 reference sequences | `"${resource_dir}/TRUST4/human_IMGT+C.fa"` |

### Workflow Behavior Parameters
| Parameter | Description | Default |
|-----------|-------------|---------|
| `chop` | Genomic interval size for parallelization (bp) | `100000000` |
| `flow_mode` | Enable Oxford Nanopore mode (true) vs Illumina mode (false) | `true` |
| `call_mito` | Enable mitochondrial variant calling | `false` |
| `use_gpu` | Enable GPU acceleration for DeepVariant | `true` |

### RNA-seq Specific Parameters
| Parameter | Description | Default |
|-----------|-------------|---------|
| `lib_stranded` | Library strandedness (no/yes/reverse) | `"no"` |
| `htseq_type` | HTSeq feature type for counting | `"exon"` |
| `run_trust4` | Enable TCR analysis with Trust4 | `true` |

## System Requirements

### Compute Resources
- **CPU**: Minimum 8 cores recommended, scales with sample count
- **Memory**: 32GB+ RAM recommended, varies by workflow:
  - scVC.nf: Up to 64GB for DeepVariant GPU processes
  - scRNA.nf: Up to 32GB for STAR alignment
- **Storage**: 500GB+ for reference data bundle and outputs
- **GPU**: Optional NVIDIA GPU for DeepVariant acceleration

### Software Dependencies
- **Nextflow**: 22.10.4 or higher
- **Singularity**: 3.8.6 or higher  
- **SLURM**: For cluster execution (configured in nextflow.config)

## Output Structure

### scVC.nf Output Structure
```
output/
├── dedup/                      # Deduplicated BAM files
│   ├── *.dedup.bam
│   ├── *.dedup.bam.bai
│   └── *.dedup.metrics.txt
├── crosscont/                  # Cross-contamination analysis
│   └── *.crosscont.table
├── ug-deepvariant/            # DeepVariant GVCF outputs
│   ├── *.g.vcf.gz
│   └── *.g.vcf.gz.tbi
├── glnexus/                   # Joint genotyping results
│   ├── <sample_id>.glnexus.vcf.gz
│   └── <sample_id>.glnexus.vcf.gz.tbi
├── bedops/                    # Genomic intervals
│   └── intervals.bed
├── chunks/                    # Split VCF chunks for annotation
│   └── *_chr*.vcf.gz
├── annovar/                   # Per-chunk annotated variants
│   └── *.hg38_multianno.vcf.gz
└── final/                     # Final merged annotated VCF
    ├── <sample_id>.vcf.gz
    └── <sample_id>.vcf.gz.tbi
```
