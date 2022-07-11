# Preliminary Results
Current as of July 11, 2022

## Loading the Data and Examining Quality
In the first file, `load_data.slurm`, I run the following commands. Note that our data is already demultiplexed (comes one sample per FASTQ file) so we refer to it as "demux-ed" which is short for "de-multiplexed":

`qiime tools import`  
Function: Imports the data into QIIME2 format    
Inputs: manifest file, typre/format of input (here, it is Phred33V2)   
Outputs:   
- **Artifacts**: demux-paired-end.qza   
- **Views**: None

`qiime demux summarize`  
Function: Summarizes the data   
Inputs: demux-paired-end.qza  
Outputs: 
- **Artifacts**: None
- **Views**: demux_before_cutadapt.qzv

`qiime cutadapt trim-paired`  
Function: Removes adapter sequences (usage for this run only, it can vary), this *does not* trim the reads!      
Inputs: The paired end artifact that was loaded previously using `qiime load`   
Outputs: an artifact and a log file 
- **Artifacts**: demux-paired-end-pre-trim.qza   
- **Views**: None
- **Other**: cutadapt_log.txt   

To view the results of the cutadapt trimming, we can summarize it again:    
`qiime demux summarize`  
Function: Summarizes the data   
Inputs: demux-paired-end-pre-trim.qza  
Outputs: 
- **Artifacts**: None
- **Views**: demux-paired-end-pre-trim.qzv

![demux-paired-end-pre-trim.qzv](https://github.com/christopherdangelo/DIG-CLL/blob/main/results/demux-paired-end-pre-trim.png)

We can see that some trimming still needs to be made.

## Denoising and Identifying the Reads
Based on the demux-paired-end-pre-trim.qzv file shown before, we can select a trim length for the reads. In this case, we need to leave some for DADA2 but also 
p_trunc_len_f=270
p_trunc_len_r=270

# The number of threads (or CPUs) to use and it must match --ntasks-per-node in header
n_threads=16

module load qiime2/2022.2

cd /work/biocore/kdempsey/elgamal/adoptive_model/fastq


echo "Starting dada2: `date`"

qiime dada2 denoise-paired \
	--i-demultiplexed-seqs artifacts/demux-paired-end-pre-trim.qza \
	--p-trunc-len-f $p_trunc_len_f \
	--p-trunc-len-r $p_trunc_len_r \
	--p-n-threads $n_threads \
	--o-table artifacts/table.qza \
	--o-representative-sequences artifacts/rep-seqs.qza \
	--o-denoising-stats artifacts/denoising-stats.qza

echo "dada2 complete: `date`"

qiime metadata tabulate \
       --m-input-file artifacts/denoising-stats.qza \
        --o-visualization artifacts/denoising-stats-viz.qzv

echo "metadata complete: `date`"

qiime feature-table filter-samples \
    --i-table artifacts/table.qza \
    --m-metadata-file metadata.tsv \
    --o-filtered-table artifacts/table.qza

echo "feature table complete: `date`"

qiime feature-table summarize \
        --i-table artifacts/table.qza \
        --o-visualization artifacts/table-viz.qzv \
        --m-sample-metadata-file metadata.tsv

echo "feature table summarize complete: `date`"

qiime feature-table tabulate-seqs \
        --i-data artifacts/rep-seqs.qza \
        --o-visualization artifacts/rep-seqs.qzv
        
        
echo "`date` - Starting mafft fasttree and diversity operations"

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

# filter out eukarya and archaea
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
