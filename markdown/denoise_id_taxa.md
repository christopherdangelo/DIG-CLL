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

**Using consensus and default DADA2 parameters:**.    
[Source](https://otagoedna.github.io/getting_started_with_qiime2/taxonomy_assignment/Exploring_Taxonomy_Assignment.html).  
Average percentage of non-chimeric reads: 26.08%   
Minimum: 12.13%   
Maximum of 46.95%  

Crane is currently down and I am waiting for results of this run.
