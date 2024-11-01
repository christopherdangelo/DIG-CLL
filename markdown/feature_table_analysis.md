## Relative Abundance plots (heatmap and barplot)
At this point we move to R (v.4.1.2); RStudio is preferred for the visual display.
Input: Folder containing the following files: metadata.tsv, norm-table.qza, taxonomy.qza
Then we run the following: [heatmaps_and_barplots.R](https://github.com/christopherdangelo/DIG-CLL/blob/main/R_scripts/heatmaps_and_barplots.R)

Here is an example output from that R script, the heatmap of relative abundance grouped by treatment for the family level:
![heatmap of abundance grouped by tx group at the family level](https://github.com/christopherdangelo/DIG-CLL/blob/main/images/heatmap_family_by_tx.png)

Here is an example output from that R script, the barplot of relative abundance grouped by treatment for the family level:
![barplot of abundance grouped by tx group at the family level](https://github.com/christopherdangelo/DIG-CLL/blob/main/images/barplot_family_by_tx.png)

### Lefse for Differential Abundance
LEfSe analysis steps:

```
module load lefse/1.0
mkdir lefse
cd lefse
```
Two scripts, `format_rel_level.sh` and `rel_format.py` are used to run Lefse. To run LEfSe, ensure that the `rel_format.py` script is in the same folder where we run `format_rel_level.sh` and then run it with `bash format_rel_level.sh`.
