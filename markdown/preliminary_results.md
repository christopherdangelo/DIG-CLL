# Preliminary Results
Current as of July 11, 2022

# Loading the Data and Examining Quality

### Import the data into QIIME 
In the first file, `load_data.slurm`, I run the following commands:

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
Function: Trims adapter sequences out (usage for this run only, it can vary)   
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


