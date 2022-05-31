## QIIME Analysis
QIIME2 version 2022.2 was used; you can invoke it by running the following command:  
`module load qiime2/2022.2`  

The documentation for QIIME2 2022.2 can be found here: https://docs.qiime2.org/2022.2/   
Please make sure that you are looking at the right documentation; it should tell you the version you are looking at in the left hand corner of the screen:  
![QIIME2 documentation](https://github.com/christopherdangelo/DIG-CLL/blob/main/images/QIIME2_documentation_website_screengrab.png)  

Phred 33 is the newer version, Phred 64 was used for older Illumina machines; this data uses Phred 33.

The commands used to load and preprocess the data include the following:

### Import the Data
```
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \   
  --input-path manifest \  
  --output-path paired-end-demux.qza \  
  --input-format PairedEndFastqManifestPhred33V2  
 ```
 ### Demultiplex ("demux") the Data, Remove Adapters, Demux again
 Demultiplexing is the process of sorting sequenced reads into separate files for each sample in a sequenced run.
 ```
qiime demux summarize \
        --i-data artifacts/demuxed-paired-end.qza \
        --o-visualization artifacts/demux.qzv

qiime cutadapt trim-paired \
        --i-demultiplexed-sequences artifacts/demuxed-paired-end.qza \
        --p-front-f TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCCTACGGGNGGCWGCAG \
        --p-front-r GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGACTACHVGGGTATCTAATCC \
        --o-trimmed-sequences artifacts/paired-end-demux-trimmed.qza \
        --verbose > cutadapt_log.txt \

qiime demux summarize \
        --i-data artifacts/paired-end-demux-trimmed.qza \
```
Cutadapt docs: https://docs.qiime2.org/2022.2/plugins/available/cutadapt/trim-paired/
