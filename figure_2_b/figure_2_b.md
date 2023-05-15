Analysis was performed on a high performance computing system using SLURM scheduling. Make sure to add the following files to the working directory:
- manifest file
- metadata.tsv file, validated 
- SILVA database formatted for QIIME

First, data was loaded:
```
#!/bin/bash
module load qiime2/2022.2

# File organization setup
cd working_directory
mkdir -p artifacts
mkdir -p exports

# Import the data into QIIME, output is a .qza and .qzv file 
qiime tools import \
	--type 'SampleData[PairedEndSequencesWithQuality]' \
	--input-path manifest \
	--input-format PairedEndFastqManifestPhred33V2 \
	--output-path artifacts/demux-paired-end.qza

qiime demux summarize \
	--i-data artifacts/demuxed-paired-end.qza \
	--o-visualization artifacts/demux_before_cutadapt.qzv

### Trims out the adapter sequences using CutAdapt
### Adapter sequences pull from Amplicon Primers section of
### 16SMetagenomicSequencingLibraryPreparation file
qiime cutadapt trim-paired \
	--i-demultiplexed-sequences artifacts/demux-paired-end.qza \
	--p-front-f TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCCTACGGGNGGCWGCAG \
	--p-front-r GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGACTACHVGGGTATCTAATCC \
	--o-trimmed-sequences artifacts/demux-paired-end-pre-trim.qza \
	--verbose > cutadapt_log.txt \

### This is a re-run of the preliminary descriptive information
### after running cutadapt to check differences
qiime demux summarize \
	--i-data artifacts/demux-paired-end-pre-trim.qza \
	--o-visualization artifacts/demux-paired-end-pre-trim.qzv

