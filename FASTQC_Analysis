# Set the search directory (points to .fastq/.fastq.gz files)
search_dir=/home/biocore/kdempsey/elgamal/fastq

# Set the output directory or where you want the fastqc reports to go
# You need to create this directory before you run this script
out_dir=/home/biocore/kdempsey/elgamal/fastqc

# On the HCC you need to use this command to load FASTQC
module load fastqc/0.11

# This command gets every file in the search directory and 
# runs FASTQC on it. This command assumes that there are only
# files of fastqc.gz in this directory; if you want to include or change
# to .fastq files you can remove the .gz from the end of line 15
for entry in "$search_dir"/*.fastq.gz
do
  echo "fastqc $entry -o $out_dir "     
  fastqc $entry -o $out_dir
done
