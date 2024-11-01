###############################
# Title: heatmaps_and_barplots.R
# 
# Set working directory to the directory which contains the following files:
# 1. metadata.tsv 
# 2. table.qza or norm-table.qza
# 3. taxonomy.qza
setwd("/work/biocore/kdempsey/elgamal/adoptive_model_abx_veh_3wk/fastq/")

# Set the category in your metadata file (i.e. "tx-group" or "timepoint"
# Name should exact match the column in the metadata file
category_title = "timepoint"

#
# Install qiime2R if needed using this command:
#if (!requireNamespace("devtools", quietly = TRUE)){install.packages("devtools")}
#devtools::install_github("jbisanz/qiime2R")
#
# or you can visit the GitHub at
# https://github.com/jbisanz/qiime2R

#
# Load libraries
# 
library(tidyverse)
library(qiime2R)

# Read in the required files: 'metadata.tsv', 'norm-table.qza', 'taxonomy.qza'
metadata <- read_q2metadata("metadata.tsv")
features_table <- read_qza("artifacts/table.qza")$data
taxonomy_table <- read_qza("artifacts/taxonomy.qza")$data  
taxonomy_table <- parse_taxonomy(taxonomy_table)


# Sumarize taxa for each level (2-7)
taxasums_p <- summarize_taxa(features_table, taxonomy_table)$Phylum
taxasums_c <- summarize_taxa(features_table, taxonomy_table)$Class
taxasums_o <- summarize_taxa(features_table, taxonomy_table)$Order
taxasums_f <- summarize_taxa(features_table, taxonomy_table)$Family
taxasums_g <- summarize_taxa(features_table, taxonomy_table)$Genus
taxasums_s <- summarize_taxa(features_table, taxonomy_table)$Species

##################################################
# By categories in your metadata file
# If there is a categorical variable in your metadata file,
# you can group the heatmaps by them
##################################################

# Plotting Heatmaps for each level (2-7)
# Phylum
heatmap_p <- taxa_heatmap(taxasums_p, metadata, category = category_title)
ggsave(paste0("heatmap_p_",category_title,".pdf"), height=4, width=8, device="pdf")
# Class
heatmap_c <- taxa_heatmap(taxasums_c, metadata, category = category_title)
ggsave(paste0("heatmap_c_",category_title,".pdf"), height=4, width=8, device="pdf")
# Order
heatmap_o <- taxa_heatmap(taxasums_o, metadata, category = category_title)
ggsave(paste0("heatmap_o_",category_title,".pdf"), height=4, width=8, device="pdf")
# Family
heatmap_f <- taxa_heatmap(taxasums_f, metadata, category = category_title)
ggsave(paste0("heatmap_f_",category_title,".pdf"), height=4, width=8, device="pdf")
# Genus
heatmap_g <- taxa_heatmap(taxasums_g, metadata, category = category_title)
ggsave(paste0("heatmap_g_",category_title,".pdf"), height=4, width=8, device="pdf")
# Species
heatmap_s <- taxa_heatmap(taxasums_s, metadata, category = category_title)
ggsave(paste0("heatmap_s_",category_title,".pdf"), height=4, width=8, device="pdf")


# Plotting Barplot for each level (2-7)
# Phylum
barplot_p <- taxa_barplot(taxasums_p, metadata, category = category_title)
ggsave(paste0("barplot_p_",category_title,".pdf"), height=4, width=8, device="pdf")
# Class
barplot_c <- taxa_barplot(taxasums_c, metadata, category = category_title)
ggsave(paste0("barplot_c_",category_title,".pdf"), height=4, width=8, device="pdf")
# Order
barplot_o <- taxa_barplot(taxasums_o, metadata, category = category_title)
ggsave(paste0("barplot_o_",category_title,".pdf"), height=4, width=8, device="pdf")
# Family
barplot_f <- taxa_barplot(taxasums_f, metadata, category = category_title)
ggsave(paste0("barplot_f_",category_title,".pdf"), height=4, width=8, device="pdf")
# Genus
barplot_g <- taxa_barplot(taxasums_g, metadata, category = category_title)
ggsave(paste0("barplot_g_",category_title,".pdf"), height=4, width=8, device="pdf")
# Species
barplot_s <- taxa_barplot(taxasums_s, metadata, category = category_title)
ggsave(paste0("barplot_s_",category_title,".pdf"), height=4, width=8, device="pdf")

#
# Some sample code from Syd and I's Feb 5 meeting
# These use ggplot for visualization so can use ggplot functionality
# to modify the aesthetic of the plots
# 
#
# For example, the code below removes the x axis entirely
#barplot_s
#barplot_s + theme(
#  axis.text.x = element_blank())
#barplot_s

# This works to remove "d__" in rownames for the taxasums_x list
# rownames(taxasums_s) <- gsub("d__","",rownames(taxasums_s))
