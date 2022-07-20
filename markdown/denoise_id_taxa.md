## Denoising with DADA2
Reads were trimmed at 275 (forward) and 275 (reverse) based on sample quality. The results of denoising can be found in the *denoising-stats.qzv* file on the shared folder.

The average percentage of non-chimeric reads that were retained from all datasets is 26.08%, with a minimum of 12.13% and a maximum of 46.95%. We can investigate if there were additional PCR primers that need to be removed from these sequences to help increase the yield (I am wondering if we are missing some primers based on the cutadapt results above hovering around 66-57%. This is not inherently concerning but could allow us to retain some more reads if we remove them).

--- under construction---
Sampling depth chosen: 32039 based on table-viz.qzv (viewed on QIIME View). This depth will retained 1,249,521 (25.14%) features in 39 (100.00%) samples. I wanted to be careful about removing too many samples since some of the groups have a lower sample count, but we can remove more if needed.

Taxa are identified in the taxonomy.qzv file but this is before any taxa are filtered out; we do remove Unassigned taxa as well as Eukaryota before plotting the taxa as bar plots: taxa-bar-plots.qzv

The taxa bar plot, before removing Unassigned and Eukaryota, is below for the Phylum level: The taxa bar plot, before removing Unassigned and Eukaryota, is below for the Phylum level:

The taxa bar plots, after removing Unassigned and Eukaryota, is below for the Phylum level:
