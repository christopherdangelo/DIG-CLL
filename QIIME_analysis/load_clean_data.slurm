#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=64000
#SBATCH --time=12:00:00
#SBATCH --job-name=adaptive_model
#SBATCH --partition=batch
#SBATCH --error=/work/biocore/kdempsey/elgamal/adaptive_model/err/err.out
#SBATCH --output=/work/biocore/kdempsey/elgamal/adaptive_model/out/out.out
#SBATCH --open-mode=append
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=kmcooper@unomaha.edu

##########################################################################
# Importe the data into QIIME2 then summarize it using demux
# Trim adapter sequnces using cutadapt then summarize it using demux
##########################################################################


module load qiime2/2022.2

cd /work/biocore/kdempsey/elgamal/adaptive_model/fastq

mkdir -p artifacts
mkdir -p exports

qiime tools import \
        --type 'SampleData[PairedEndSequencesWithQuality]' \
        --input-path manifest \
        --input-format PairedEndFastqManifestPhred33V2 \
        --output-path artifacts/demuxed-paired-end.qza

qiime demux summarize \
        --i-data artifacts/demuxed-paired-end.qza \
        --o-visualization artifacts/demux.qzv

qiime cutadapt trim-paired \
        --i-demultiplexed-sequences artifacts/demuxed-paired-end.qza \
        --p-front-f CCTACGGGNGGCWGCAG \
        --p-front-r GACTACHVGGGTATCTAATCC \
        --o-trimmed-sequences artifacts/paired-end-demux-trimmed.qza \
        --verbose > cutadapt_log.txt \

qiime demux summarize \
        --i-data artifacts/paired-end-demux-trimmed.qza \
        --o-visualization artifacts/paired-end-demux-trimmed.qzv
