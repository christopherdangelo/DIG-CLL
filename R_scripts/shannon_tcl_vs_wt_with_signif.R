#############################
# Author: Kate Cooper, kmcooper [at] unomaha [dot] edu
# Created: June 29, 2022
# Last Updated: See GitHub for versioning
# Description: This uses the Shannon Entropy output from our 
# workflow to determine the diversity of each sample
#
# Library Requirements:
#  - tidyr
#  - ggplot2
#  - tidyverse
#  - ggpubr
# 
# Input:
#  -  metadata_shannon.tsv: your metadata file containing the shannon entropy data
#  -  You will need to change the variables to match the metadata you are looking at
#
# Output:
# - Currently I run this script in RStudio, so it just prints the plot to the RStudio 
# - console output. I save the file from there. We can update it to print to a file later
###############################
library(tidyr)
library(ggplot2)
library(tidyverse)
library(ggpubr)
setwd("/Users/kmcooper/Downloads/")

### YOU NEED TO REMOVE THE SECOND LINE OF THE FILE
## You can use the efficient_metadata.py script to do this for this experiment only
file <- read_tsv("metadata.tsv")
data <- data.frame(file)

x_name = "Type"
# Boxplot by Tx only using Wilcoxon for significance (Unpaired, 2 groups, non parametric)
my_comparisons <- list( c("WT", "TCL1"))
ch <- ggplot(data,aes(x=genotype,y=shannon_entropy,fill=genotype)) + geom_boxplot() + scale_x_discrete(breaks = seq(0,9,1),name ="Type") +scale_y_continuous(breaks = seq(0,9,0.25),name ="Discrete") +
  stat_compare_means(comparisons = my_comparisons)
stat_compare_means(label = "p.signif", method = "wilcox.test", ref.group = "0.5")    
ch + theme(axis.text.x = element_text(face="bold", color="black", size=8, angle=90),
           axis.text.y = element_text(face="bold", color="black", size=8, angle=90)) 
ggsave("shannon.png",plot = ch)
