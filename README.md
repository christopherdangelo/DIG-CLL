# DIG-CLL 

## Project Navigation
- [Project Computational Dependencies](https://github.com/christopherdangelo/DIG-CLL/blob/main/markdown/project_dependencies.md)
- [Data Download and Description](https://github.com/christopherdangelo/DIG-CLL/blob/main/markdown/data_description.md)
- [Project Computing Environment: Holland Computing Center](https://hcc.unl.edu/)
- [Initial Data Quality Check](https://github.com/christopherdangelo/DIG-CLL/blob/main/markdown/initial_quality_check.md)
- [Pre-processing in QIIME](https://github.com/christopherdangelo/DIG-CLL/blob/main/markdown/qiime_preprocess.md)

## QIIME Analysis
QIIME2 version 2022.2 was used; you can invoke it by running the following command:  
`module load qiime2/2022.2`  
The documentation for QIIME2 2022.2 can be found here: https://docs.qiime2.org/2022.2/   
Please make sure that you are looking at the right documentation; it should tell you the version you are looking at in the left hand corner of the screen:  
![QIIME2 documentation](https://github.com/christopherdangelo/DIG-CLL/blob/main/images/QIIME2_documentation_website_screengrab.png)  

Phred 33 is the newer version, Phred 64 was used for older Illumina machines; this data uses Phred 33 
```
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \   
  --input-path manifest \  
  --output-path paired-end-demux.qza \  
  --input-format PairedEndFastqManifestPhred33V2  
```
### Microbiome Work


