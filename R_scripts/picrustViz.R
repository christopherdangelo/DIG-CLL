#if(!requireNamespace("BiocManager")){
#  install.packages("BiocManager")
#}
#BiocManager::install("phyloseq")

#install.packages("ggpicrust2")
library(readr)
library(ggpicrust2)
library(tibble)
library(tidyverse)
library(ggprism)
library(patchwork)

filepath = "/work/biocore/kdempsey/elgamal/adoptive_model_abx_only_0_1_3_5_7wk/fastq"
# Load necessary data: abundance data and metadata
abundance_file <- paste0(filepath,"/picrust/picrust.out/KO_metagenome_out/pred_metagenome_unstrat.tsv")

unzipCom = paste0("gunzip ",abundance_file,".gz")
system(unzipCom)
metadata <- read_delim(
  paste0(filepath,"/metadata.tsv"),
  delim = "\t",
  escape_double = FALSE,
  trim_ws = TRUE
)
metadata = metadata[-c(1), ]


# Load KEGG pathway abundance
kegg_abundance <- ko2kegg_abundance(abundance_file)


# Perform pathway differential abundance analysis (DAA) using edgeR method
# Replace "Peatland" with your actual group column name if not using the example dataset
daa_results_df <- pathway_daa(abundance = kegg_abundance, metadata = metadata, group = "timepoint", daa_method = "edgeR", select = NULL, reference = NULL)
daa_annotated_results_df <- pathway_annotation(pathway = "KO", daa_results_df = daa_results_df, ko_to_kegg = TRUE)

# Generate pathway PCA plot
# Replace "Peatland" with your actual group column name if not using the example dataset
pca_plot <- pathway_pca(abundance = kegg_abundance, metadata = metadata, group = "timepoint")

# Generate pathway heatmap
heatmap_plot <- pathway_heatmap(abundance = kegg_abundance, metadata = metadata, group = "timepoint")

#p <- pathway_errorbar(abundance = kegg_abundance,
#                      daa_results_df = daa_annotated_results_df,
#                      Group = "timepoint",
#                      ko_to_kegg = TRUE,
#                      p_values_threshold = 0.05,
#                      order = "pathway_class",
#                      select = c("ko05412","ko03450"),
#                      p_value_bar = TRUE,
#                      colors = NULL,
#                     x_lab = "pathway_name")

topPathways = daa_results_df %>% filter(p_adjust < 0.05) %>% select(c("feature","p_adjust"))
p <- pathway_errorbar(abundance = kegg_abundance, daa_results_df = daa_annotated_results_df, Group = metadata$timepoint, p_values_threshold = 0.05, order = "pathway_class", select = topPathways$feature[1:10], ko_to_kegg = TRUE, p_value_bar = TRUE, colors = NULL, x_lab = "pathway_name")

#daa_sub_method_results_df <- daa_results_df[daa_results_df$method == "Maaslin2", ]

# Annotate pathway results without KO to KEGG conversion
#daa_annotated_sub_method_results_df <- pathway_annotation(pathway = "KO", daa_results_df = daa_sub_method_results_df, ko_to_kegg = FALSE)

#p <- pathway_errorbar(abundance = kegg_abundance,
#                      daa_results_df = daa_annotated_sub_method_results_df,
#                      Group = "timepoint",
#                      ko_to_kegg = TRUE,
#                      p_values_threshold = 0.05,
#                      order = "pathway_class",
#                      select = NULL,
#                      p_value_bar = TRUE,
#                      colors = NULL,
#                      x_lab = "pathway_name")

pdf(file = paste0(filepath,"/picrust/ggpicrust2.pdf"),width = 11)
pca_plot
heatmap_plot
p
dev.off()
### Uncomment the code below if using Maaslin2
#mvCom = paste0("mv /home/biocore/kdempsey/Maaslin2_results_timepoint ",filepath,"/picrust/")
#system(mvCom)
#makeCom1 = paste0("mkdir -p /home/biocore/kdempsey/Maaslin2_results_timepoint/")
#makeCom2 = paste0("touch /home/biocore/kdempsey/Maaslin2_results_timepoint/maaslin2.log")
#system(makeCom1)
#system(makeCom2)
rm(p)
rm(pca_plot)
rm(heatmap_plot)
rm(daa_results_df)
rm(daa_annotated_results_df)

