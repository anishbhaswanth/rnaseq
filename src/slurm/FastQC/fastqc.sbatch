#!/bin/bash
#
#SBATCH --job-name=fastqc
#SBATCH -c 1
#SBATCH -t 1-00:00 # Runtime in D-HH:MM
#SBATCH --output=fastqc-%A_%a.out
#SBATCH --array=0-5 # job array index

module purge
module load fastqc/0.11.9

## base dir
proj_dir=.

## input variables
fastq_dir=${proj_dir}/Fastq/Raw # raw files
sample_list=../samples_list.txt # sample list
names=($(cat $sample_list))

## output variables
fastqc_out=${proj_dir}/QC/FastQC

## create output directories
mkdir -p $fastqc_out

echo ${names[${SLURM_ARRAY_TASK_ID}]}

## run fastqc
fastqc -o $fastqc_out $fastq_dir/${names[${SLURM_ARRAY_TASK_ID}]}_R1_001.fastq.gz
fastqc -o $fastqc_out $fastq_dir/${names[${SLURM_ARRAY_TASK_ID}]}_R2_001.fastq.gz
