## Denoising with DADA2
Reads were trimmed at 275 (forward) and 275 (reverse) based on sample quality. The results of denoising can be found in the *denoising-stats.qzv* file on the shared folder.

### Reducing Chimeras SELECTED Method
**SELECTED: Using sklearn and default DADA2 parameters with parent parameter increased (4):**    
```
--p-min-fold-parent-over-abundance 4   
```
Average percentage of non-chimeric reads: 27.35%   
Minimum: 13.57%   
Maximum of 47.13%  

### Reducing Chimeras: Other options I tried are below
**Using sklearn and default DADA2 parameters:** 
Average percentage of non-chimeric reads: 26.08%  
Minimum: 12.13%   
Maximum of 46.95%   
We can investigate if there were additional PCR primers that need to be removed from these sequences to help increase the yield. This looks like a chimera problem - do we know how many cycles of PCR were run?    

**Using consensus and default DADA2 parameters:**.    
[Source](https://otagoedna.github.io/getting_started_with_qiime2/taxonomy_assignment/Exploring_Taxonomy_Assignment.html).  
Average percentage of non-chimeric reads: 26.08%   
Minimum: 12.13%   
Maximum of 46.95%  

**Using consensus and DADA2 parameters with parent parameter increased (4):**.    
```
--p-min-fold-parent-over-abundance 4   
```
Average percentage of non-chimeric reads: 27.35%   
Minimum: 13.57%   
Maximum of 47.13% 

### Sampling Depth
Sampling depth chosen: 8398 based on `table-viz.qzv` (viewed on QIIME View). This depth will retain 864,994 (27.74%) features in 103 (100.00%) samples at the specifed sampling depth. I wanted to be careful about removing too many samples since some of the groups have a lower sample count after chimera removal, but we can remove more if needed. 

Taxa are identified in the `taxonomy.qzv` file; we also view the taxa as bar plots: `taxa-bar-plots.qzv`

The taxa bar plots, _after_ removing Unassigned and Eukaryota, is below for the Phylum level:
![taxa bar plots for phylum level](https://github.com/christopherdangelo/DIG-CLL/blob/main/results/taxa_barplot_phylum.png)

Distribution of samples after sampling depth chosen:
![sample distribution after sampling depth chosen](https://github.com/christopherdangelo/DIG-CLL/blob/main/results/table_viz_qza.png)

## Normalization using SRS
Normalization using SRS (scaling with ranked subsampling) method:
The amplicon sequence variant (ASV) file found in the artifacts directory, `table.qza`, was uploaded to the [SRS Shiny app ](https://vitorheidrich.shinyapps.io/srsshinyapp/) in order to choose a sampling depth (Cmin) or the normalization cut-off value. The selection of a Cmin of 2250 allows for retention of 95 out of 103 samples (92.23%) and a % retained diversity  ranging from 63.6-100% per sample. The following samples were discarded as a result of this decision:
1. 100-S100-L001 (Abx-9wk-Post-Eng)
2. 102-S102-L001 (Abx-9wk-Post-Eng)
3. 103-S103-L001 (Abx-9wk-Post-Eng)
4. 99-S99-L001 (Abx-9wk-Post-Eng)
5. 80-S80-L001 (Abx-5wk-Post-Eng)
6. 83-S83-L001 (Abx-5wk-Post-Eng)
7. 87-S87-L001 (Abx-7wk-Post-Eng)
8. 93-S93-L001 (Abx-7wk-Post-Eng)

![SRS Shiny Cmin selection](https://github.com/christopherdangelo/DIG-CLL/blob/main/results/srs_curves.png)

Once a value for Cmin has been chosen, the following qiime command can be run:
```
#!/bin/bash

module load qiime2/2021.4

qiime srs SRS   \
    --i-table artifacts/table.qza   \
    --p-c-min 4500   \
    --o-normalized-table artifacts/norm-table.qza   \
    --verbose
    
qiime feature-table summarize \
    --i-table artifacts/norm-table.qza \
    --o-visualization artifacts/norm-table.qzv
```

