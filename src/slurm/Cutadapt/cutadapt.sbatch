#!/bin/bash
#
#SBATCH --job-name=cutadapt
#SBATCH -c 12
#SBATCH -t 16:00:00
#SBATCH --output=OUT/cutadapt_%A_%a.out
#SBATCH --array=0-11 # job array index

module load cutadapt/1.18

## base dir
proj_dir=.

## input variables
fastq_dir=${proj_dir}/Fastq/Raw # raw files
sample_list=../samples_list.txt # sample list
names=($(cat $sample_list))

## output variables
out=${proj_dir}/Fastq/Cutadapt # store trim files

# create output directories
mkdir -p $out

echo ${names[${SLURM_ARRAY_TASK_ID}]}

_R1_001.fastq.gz

cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
        -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
        -o $out/${names[${SLURM_ARRAY_TASK_ID}]}_R1_001.cutadapt.fastq.gz \
        -p $out/${names[${SLURM_ARRAY_TASK_ID}]}_R2_001.cutadapt.fastq.gz \
        -m 25 \
        -q 15 \
        $fastq_dir/${names[${SLURM_ARRAY_TASK_ID}]}_R1_001.fastq.gz \
        $fastq_dir/${names[${SLURM_ARRAY_TASK_ID}]}_R2_001.fastq.gz

