## Dataset Description
"Adoptive Transfer model" refers to 16s rRNA analysis of fecal pellets from mice treated with antibiotics + controls.  
"Progression model" refers to 16s rRNA analysis of fecal pellets untreated mice collected over time.

## Data Download

### Progression Model/TCL-1
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

### Transfer to HCC
The bash scp command was used to transfer data to the [Holland Computing Center](https://hcc.unl.edu/) for analysis.

