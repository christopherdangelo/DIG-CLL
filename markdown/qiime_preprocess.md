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
### Import the data into QIIME 
### Output is a QIIME artifact (.qza) and a view (.qzv) 
### View files can be visualized on QIIME dot com
### These files come demultiplexed (each sample in its own fastq)
### so we do not need to demultiplex them
qiime tools import \
        --type 'SampleData[PairedEndSequencesWithQuality]' \
        --input-path manifest \
        --input-format PairedEndFastqManifestPhred33V2 \
        --output-path artifacts/demux-paired-end.qza
 ```
 ### QIIME demux
 This data is demultiplexed already but we can use the demux command to summarize it. Demultiplexing (or to "demux") the datais the process of sorting sequenced reads into separate files for each sample in a sequenced run. In this case, the data came to use demultiplexed and therefore we do not need to demux it. If your data came with barcodes or as one single fastq file with all the samples in it, then you need to demultiplex the data.
 ```
### Here we are using the demux command but 
### this just gives some preliminary descriptive information
qiime demux summarize \
        --i-data artifacts/demuxed-paired-end.qza \
        --o-visualization artifacts/demux_before_cutadapt.qzv

### This trims out the adapter sequences
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
### Cutadapt
Cutadapt is used to remove the adapter primers as described above. 
Cutadapt docs can be found by [clicking here](https://docs.qiime2.org/2022.2/plugins/available/cutadapt/trim-paired/).
For the adapter sequences, here is the summary log provided after cutadapt indicating that the adapter primers were found and removed:
```
This is cutadapt 4.0 with Python 3.8.13
Command line parameters: --cores 1 --error-rate 0.1 --times 1 --overlap 3 --minimum-length 1 -o /tmp/q2-CasavaOneEightSingleLanePerSampleDirFmt-yy6uu_bm/1-S1-L001_14_L001_R1_001.fastq.gz -p /tmp/q2-CasavaOneEightSingleLanePerSampleDirFmt-yy6uu_bm/1-S1-L001_117_L001_R2_001.fastq.gz --front TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCCTACGGGNGGCWGCAG -G GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGACTACHVGGGTATCTAATCC /tmp/qiime2-archive-8mm_6x0r/55bd7cc2-d626-4d22-9282-5d4be4d30a9d/data/1-S1-L001_14_L001_R1_001.fastq.gz /tmp/qiime2-archive-8mm_6x0r/55bd7cc2-d626-4d22-9282-5d4be4d30a9d/data/1-S1-L001_117_L001_R2_001.fastq.gz
Processing paired-end reads on 1 core ...
Finished in 16.05 s (115 µs/read; 0.52 M reads/minute).

=== Summary ===

Total read pairs processed:            139,589
  Read 1 with adapter:                 138,713 (99.4%)
  Read 2 with adapter:                 138,020 (98.9%)

== Read fate breakdown ==
Pairs that were too short:                   0 (0.0%)
Pairs written (passing filters):       139,589 (100.0%)

Total basepairs processed:    83,883,422 bp
  Read 1:    42,003,712 bp
  Read 2:    41,879,710 bp
Total written (filtered):     78,633,404 bp (93.7%)
  Read 1:    39,648,615 bp
  Read 2:    38,984,789 bp
```
