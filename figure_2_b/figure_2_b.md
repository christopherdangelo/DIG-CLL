Analysis was performed on a high performance computing system using SLURM scheduling. Make sure to add the following files to the working directory:
- manifest file
- metadata.tsv file, validated 
- SILVA database formatted for QIIME
Panel A was created from the folder named progression_model_3_excl on the HPC system.

First, data was loaded and trimmed:
```
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
```

Next, the trimmed data was uploaded and denoised using DADA2. Eurkayotes and Archaebacteria are removed:"
```
# DADA2 denoising parameters - trim length - are defined below
p_trunc_len_f=280
p_trunc_len_r=255
n_threads=16

module load qiime2/2022.2

cd working_directory

qiime dada2 denoise-paired \
	--i-demultiplexed-seqs artifacts/demux-paired-end-pre-trim.qza \
	--p-trunc-len-f $p_trunc_len_f \
	--p-trunc-len-r $p_trunc_len_r \
	--p-n-threads $n_threads \
	--o-table artifacts/table.qza \
	--o-representative-sequences artifacts/rep-seqs.qza \
	--o-denoising-stats artifacts/denoising-stats.qza

qiime metadata tabulate \
       --m-input-file artifacts/denoising-stats.qza \
        --o-visualization artifacts/denoising-stats-viz.qzv

qiime feature-table filter-samples \
    --i-table artifacts/table.qza \
    --m-metadata-file metadata.tsv \
    --o-filtered-table artifacts/table.qza

qiime feature-table summarize \
        --i-table artifacts/table.qza \
        --o-visualization artifacts/table-viz.qzv \
        --m-sample-metadata-file metadata.tsv

qiime feature-table tabulate-seqs \
        --i-data artifacts/rep-seqs.qza \
        --o-visualization artifacts/rep-seqs.qzv

qiime phylogeny align-to-tree-mafft-fasttree \
        --i-sequences artifacts/rep-seqs.qza \
        --o-alignment artifacts/aligned-rep-seqs.qza \
        --o-masked-alignment artifacts/masked-aligned-rep-seqs.qza \
        --o-tree artifacts/unrooted-tree.qza \
        --o-rooted-tree artifacts/rooted-tree.qza

qiime feature-classifier classify-sklearn \
        --i-classifier silva-138-99-nb-classifier.qza \
        --i-reads artifacts/rep-seqs.qza \
        --o-classification artifacts/taxonomy.qza

qiime metadata tabulate \
        --m-input-file artifacts/taxonomy.qza \
        --o-visualization artifacts/taxonomy.qzv
	
qiime taxa filter-table \
    --i-table artifacts/table.qza \
    --i-taxonomy artifacts/taxonomy.qza \
    --p-exclude eukarya,archaea \
    --o-filtered-table artifacts/table.qza

qiime taxa barplot \
    --i-table artifacts/table.qza \
    --i-taxonomy artifacts/taxonomy.qza \
    --m-metadata-file metadata.tsv \
    --o-visualization artifacts/taxa-bar-plots.qzv
```
