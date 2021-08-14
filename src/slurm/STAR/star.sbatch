#!/bin/bash
#
#SBATCH --job-name=STAR
#SBATCH -N 1 #
#SBATCH -t 1-00:00 # D-H:M
#SBATCH --cpus-per-task=12 # Request that ncpus be allocated per process.
#SBATCH --mem=60g
#SBATCH --array=0-11 # job array index  
#SBATCH --output=OUT/star-%A_%a.out

# load modules
module purge
module load star/2.7.5a

set -x

## base dir
proj_dir=.

## input variables
genome_dir=/bgfs/genomics/refs/refs/Homo_sapiens/Gencode/GRCh38/STAR
fastq_dir=${proj_dir}/Fastq/Cutadapt # cutadapt files

sample_list=../samples_list.txt # sample list
names=($(cat $sample_list))
sample=${names[${SLURM_ARRAY_TASK_ID}]}

## output variables
out=${proj_dir}/STAR/${sample}

## create output directories
mkdir -p $out

## run STAR mapping

STAR \
    --readFilesIn $fastq_dir/${sample}_R1_001.cutadapt.fastq.gz $fastq_dir/${sample}_R2_001.cutadapt.fastq.gz \
    --outSAMattrRGline ID:$sample \
    --alignIntronMax 1000000 \
    --alignIntronMin 20 \
    --alignMatesGapMax 1000000 \
    --alignSJDBoverhangMin 1 \
    --alignSJoverhangMin 8 \
    --alignSoftClipAtReferenceEnds Yes \
    --chimJunctionOverhangMin 15 \
    --chimMainSegmentMultNmax 1 \
    --chimOutType Junctions SeparateSAMold WithinBAM SoftClip \
    --chimSegmentMin 15 \
    --genomeDir $genome_dir \
    --genomeLoad NoSharedMemory \
    --limitSjdbInsertNsj 1200000 \
    --outFileNamePrefix $out/${sample} \
    --outFilterIntronMotifs None \
    --outFilterMatchNminOverLread 0.33 \
    --outFilterMismatchNmax 999 \
    --outFilterMismatchNoverLmax 0.1 \
    --outFilterMultimapNmax 20 \
    --outFilterScoreMinOverLread 0.33 \
    --outFilterType BySJout \
    --outSAMattributes NH HI AS nM NM ch \
    --outSAMstrandField intronMotif \
    --outSAMtype BAM SortedByCoordinate \
    --outSAMunmapped Within \
    --quantMode TranscriptomeSAM GeneCounts \
    --readFilesCommand zcat \
    --runThreadN $SLURM_CPUS_ON_NODE \
    --twopassMode Basic
