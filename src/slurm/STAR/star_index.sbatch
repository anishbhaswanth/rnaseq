#!/bin/bash
#
#SBATCH --job-name=STAR_index
#SBATCH -N 1 #
#SBATCH -t 12:00:00
#SBATCH --cpus-per-task=12 # Request that ncpus be allocated per process.
#SBATCH --mem=60g
#SBATCH --output=star_index.out

module load star/2.7.5a

set -x

## input variables
ref_fa=
gtf=
#ref_fa=/bgfs/genomics/refs/refs/Homo_sapiens/Gencode/GRCh38/GRCh38.primary_assembly.genome.fa
#gtf=/bgfs/genomics/refs/refs/Homo_sapiens/Gencode/GRCh38/gencode.v38.primary_assembly.annotation.gtf

## output variables
genome_dir=
#genome_dir=/bgfs/genomics/refs/refs/Homo_sapiens/Gencode/GRCh38/STAR

mkdir -p $genome_dir

STAR \
  --runMode genomeGenerate \
  --genomeDir $genome_dir \
  --genomeFastaFiles $ref_fa \
  --sjdbOverhang 100 \
  --sjdbGTFfile $gtf \
  --runThreadN $SLURM_CPUS_ON_NODE
