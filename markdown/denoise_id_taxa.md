## Denoising with DADA2
Reads were trimmed at 275 (forward) and 275 (reverse) based on sample quality. The results of denoising can be found in the *denoising-stats.qzv* file on the shared folder.

### Reducing Chimeras
**Using sklearn and default DADA2 parameters:** 
Average percentage of non-chimeric reads: 26.08%
Minimum: 12.13% 
Maximum of 46.95%
We can investigate if there were additional PCR primers that need to be removed from these sequences to help increase the yield. This looks like a chimera problem - do we know how many cycles of PCR were run?

**Using sklearn and default DADA2 parameters with parent parameter increased:**
--p-min-fold-parent-over-abundance 4
Average percentage of non-chimeric reads: 27.35%
Minimum: 13.57% 
Maximum of 47.13%

**Using consensus and default DADA2 parameters:**
[Source](https://otagoedna.github.io/getting_started_with_qiime2/taxonomy_assignment/Exploring_Taxonomy_Assignment.html)


--- under construction---
Sampling depth chosen: 32039 based on table-viz.qzv (viewed on QIIME View). This depth will retained 1,249,521 (25.14%) features in 39 (100.00%) samples. I wanted to be careful about removing too many samples since some of the groups have a lower sample count, but we can remove more if needed.

Taxa are identified in the taxonomy.qzv file but this is before any taxa are filtered out; we do remove Unassigned taxa as well as Eukaryota before plotting the taxa as bar plots: taxa-bar-plots.qzv

The taxa bar plot, before removing Unassigned and Eukaryota, is below for the Phylum level: The taxa bar plot, before removing Unassigned and Eukaryota, is below for the Phylum level:

The taxa bar plots, after removing Unassigned and Eukaryota, is below for the Phylum level:
