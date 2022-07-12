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
file <- read_tsv("metadata_shannon.tsv")
data <- data.frame(file)

# Boxplot by Tx only using Wilcoxon for significance (Unpaired, 2 groups, non parametric)
my_comparisons <- list( c("Veh", "Abx"))
ch <- ggplot(data,aes(x=tx.group,y=shannon_entropy,fill=tx.group)) +
      geom_boxplot() + scale_x_discrete(name ="Tx Group") +  scale_y_continuous(breaks = seq(0,9,1),name ="Shannon Entropy") +
      stat_compare_means(comparisons = my_comparisons)
stat_compare_means(label = "p.signif", method = "wilcox.test", ref.group = "0.5")    
ch + theme(axis.text.x = element_text(face="bold", color="black", size=8, angle=90),
           axis.text.y = element_text(face="bold", color="black", size=8, angle=90)) 

# Boxplot of Tx by timepoint and using Kruskal Wallis for significance
# Change the my_comparisons variables at line 40 to change the pairs that get compared for significance
my_comparisons <- list( c("Veh-0", "Abx-0"), c("Veh-1wk", "Abx-1wk"), c("Veh-3wk", "Abx-3wk"),c("Veh-5wk","Abx-5wk"),c("Veh-7wk","Abx-7wk"),c("Veh-9wk","Abx-9wk"))
ch <- ggplot(data,aes(x=timepoint,y=shannon_entropy,fill=tx.group)) +
      geom_boxplot() + scale_x_discrete(name ="Tx Group over Time") +  scale_y_continuous(breaks = seq(0,9,1),name ="Shannon Entropy") +
      stat_compare_means(comparisons = my_comparisons)
stat_compare_means(label = "p.signif", method = "kruskal.test", ref.group = ".all.")    
ch + theme(axis.text.x = element_text(face="bold", color="black", size=8, angle=90),
           axis.text.y = element_text(face="bold", color="black", size=8, angle=90)) 


