#!/bin/bash
#
#SBATCH --job-name=HT-Seq
#SBATCH -N 1 #
#SBATCH -t 12:00:00 #
#SBATCH --cpus-per-task=12 # Request that ncpus be allocated per process.
#SBATCH --mem=60g
#SBATCH --array=0-11 # job array index  
#SBATCH --output=OUT/htseq-%A_%a.out

# load modules
module load htseq/0.13.5

set -x

## base dir
proj_dir=.

## input variables
#gtf=/bgfs/genomics/refs/refs/Homo_sapiens/Gencode/GRCh38/gencode.v38.primary_assembly.annotation.gtf
gtf=/bgfs/genomics/refs/refs/Mus_musculus/Gencode/GRCm39/gencode.vM27.primary_assembly.annotation.gtf
bam_dir=${proj_dir}/STAR # BAM folder

sample_list=../samples_list.txt # sample list
names=($(cat $sample_list))
sample=${names[${SLURM_ARRAY_TASK_ID}]}

## output variables
out=${proj_dir}/HT-Seq

## create output directories
mkdir -p $out

## run ht-seq
htseq-count \
    -f bam \
    -r pos \
    -s no \
    -a 10 \
    -t exon \
    -i gene_id \
    -m intersection-nonempty \
    $bam_dir/${sample}/${sample}Aligned.sortedByCoord.out.bam \
    $gtf > $out/${sample}.counts.txt

