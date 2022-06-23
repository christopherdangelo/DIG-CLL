## Denoising with DADA2
```
# Identify the trim/trunc length for DADA2 based on QC analysis 
# Number of threads will depend on your computing environment
p_trunc_len_f=270
p_trunc_len_r=270
n_threads=16

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
```

```
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
```



