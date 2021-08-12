#!/bin/bash
#
#SBATCH --job-name=STAR_index
#SBATCH -N 1 #
#SBATCH -t 12:00:00
#SBATCH --cpus-per-task=12 # Request that ncpus be allocated per process.
#SBATCH --mem=60g
#SBATCH --output=star_index.out

module load star/2.7.5a

# input variables
ref_fa=
gtf=

# output variables
genome_dir=

mkdir -p $genome_dir

STAR \
  --runMode genomeGenerate \
  --genomeDir $genome_dir \
  --genomeFastaFiles $ref_fa \
  --sjdbOverhang 100 \
  --sjdbGTFfile $gtf \
  --runThreadN $SLURM_CPUS_ON_NODE