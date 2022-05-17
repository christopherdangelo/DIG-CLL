# DIG-CLL 

## Project Navigation
- [Project Computational Dependencies](https://github.com/christopherdangelo/DIG-CLL/blob/main/markdown/project_dependencies.md)
- [Data Download and Description](https://github.com/christopherdangelo/DIG-CLL/blob/main/markdown/data_description.md)

## Dataset Description
"Adoptive Transfer model" refers to 16s rRNA analysis of fecal pellets from mice treated with antibiotics + controls.  
"Progression model" refers to 16s rRNA analysis of fecal pellets untreated mice collected over time.

## Data Download
### Adoptive Transfer Model
Data was downloaded from Illumina BaseSpace on April 29, 2022 using the BaseSpace Downloader Tool. 
- 103 Paired-End sample reads were downloaded. They are named using the following syntax:
  - `100_S100_L001` indicates a unique ID + _ + sample ID + _ + run ID and then followed by 
  -  R1 for forward reads and R2 for reverse reads
  -  206 files total, stored in gz format (fastq.gz) 
- Total File Size reported by Illumina: 5.58Gb
  - BaseSpace downloader (3Gb) 
  - HCC (4Gb)
  - Online BaseSpace (5Gb)
- Illumina reports 268,790 total raw reads in the dataset
- Data was then moved to the `/home/biocore/kdempsey/elgamal/adoptive_model/fastq/` folder

### Progression Model
Data was downloaded from Illumina BaseSpace on May 10, 2022 using the BaseSpace Downloader Tool. 
- 91 Paired-End sample reads were downloaded. They are named using the following syntax:
  - `100_S100_L001` indicates a unique ID + _ + sample ID + _ + run ID and then followed by 
  -  R1 for forward reads and R2 for reverse reads
  -  182 files total, stored in gz format (fastq.gz)
- Total File Size reported by Illumina: 7.08Gb
  - BaseSpace downloader (5.34Gb) 
  - HCC (4Gb)
  - Online BaseSpace (7.08Gb)
- Illumina reports 339,982 total raw reads in the dataset
- Data was then moved to the `/home/biocore/kdempsey/elgamal/progression_model/fastq/` folder

### Transfer to HCC
Kate will add details (this is relatively simple) at a later date. SCP was used on the command line

## FastQC Analysis
Each file was run through FASTQC 0.11.7. Results can be found under `/home/biocore/kdempsey/elgamal/fastqc/` 
1. Software can be loaded on HCC using `module load fastqc/0.11`
2. The script used to run the fastqc analysis can be found here: [run_fastqc.sh](https://github.com/christopherdangelo/DIG-CLL/blob/main/FASTQC_Analysis/run_fastqc.sh)
3. To run the command, use `sh run_fastqc.sh`
This command was short enough to run on the login node, but could be transformed into a SLURM file later if it becomes problematic.

After this run was completed, we wanted to determine if adapter sequences needed to be removed and also determine a universal length to use to trim the reads that would ensure high quality data. All data was considered high quality but trimming it further allows us to guarantee quality scores above a certain threshold.

### Checking Adapter Content
1. Navigate to the directory where FASTQC folders are located. 
2. FASTQC puts all the results in a .zip file with accompanying HTML file. Since we are looking at a larger number of files remotely we do not want to 'spot check' each by eye. We need to access the data in txt format. 
3. To do this, we unzip all the fastqc files in the fastqc directory using this script: [unzip_fastqc.sh](https://github.com/christopherdangelo/DIG-CLL/blob/main/FASTQC_Analysis/unzip_fastqc.sh)
4. Each zip file then gets expanded to a folder named after the .fastq file it was created for and contains a number of files. We want to access the `fastqc_data.txt` file, which contains the same information that is contained the report's HTML file ([an example can be found here](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/good_sequence_short_fastqc.html#M10).
5. We used a simple grep statement to check and see how many of each of these files passed the 'Adapter Content' test in FASTQC:
```
# From the FASTQC directory, on the command line, type:
cat */fastqc_data.txt | grep "Adapter Content" | grep "PASS" -i | wc -l
cat */fastqc_data.txt | grep "Adapter Content" | grep "FAIL" -i | wc -l
```
#### Adoptive Model
We have 103 samples and therefore 206 read files (one forward .fastq.gz and one reverse .fastq.gz file per sample). We should see 206 files passing the Adapter Content test:
```
$ cat */fastqc_data.txt | grep "Adapter Content" | grep pass -i | wc -l  
206  
$ cat */fastqc_data.txt | grep "Adapter Content" | grep fail -i | wc -l  
0
```
#### Progression Model
We have 91 samples and therefore 182 read files (one forward .fastq.gz and one reverse .fastq.gz file per sample). We should see 182 files passing the Adapter Content test:
```
$ cat */fastqc_data.txt | grep "Adapter Content" | grep pass -i | wc -l  
182  
$ cat */fastqc_data.txt | grep "Adapter Content" | grep fail -i | wc -l  
0
```

### Identifying a Read Length Minimum Threshold
- Create a list of the fastqc data files (does not have to be absolute path, just need to run script from the directory where the files are). To do this, I ran the following command:
```
# Navigate to the folder where you will be running the Python script
# This is most likely the fastqc folder containing unzipped subfolders with fastqc results
# See the 'Checking Adapter Content' to see how to do this automatically
ls -la */fastqc_data.txt > fastqc_data_files.list
```
This generates a file called `fastqc_data_files.list`. You can store this in the fastqc folder or wherever you prefer, just keep track of where this list is. Then, you can run the Python 3 script found here: [parse_fastq_data.py](https://github.com/christopherdangelo/DIG-CLL/blob/main/FASTQC_Analysis/parse_fastqc_data.py)
```
python3 parse_fastqc_data.py | sort | uniq
```
This Python script opens each FASTQC report summary and identifies at what length the reads in that report fall below some quality threshold coded in the Python script as the `threshold` variable. The output of this script + bash commands will give you the lengths at which reads in that dataset start to fall below the quality threshold.
#### Adoptive Model
```
python3 ~/elgamal/bin/parse_fastqc_data.py | sort | uniq
**205-209**
220-224
225-229
245-249
250-254
265-269
270-274
285-289
290-294
```
#### Progression Model
```
python3 ~/elgamal/bin/parse_fastqc_data.py | sort | uniq
**205-209**
220-224
225-229
245-249
250-254
265-269
270-274
285-289
290-294
```

From this analysis using a quality score threshold of **28**, we see that if we want to trim reads to having a quality score higher than 28, we should trip them to length of 205 or less. (Reads are 300bp long off this machine)

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


