# Set the search directory (points to the fastqc .zip files)
search_dir=/home/biocore/kdempsey/elgamal/fastqc

# This command gets every .zip file in the search directory and 
# runs unzip on it which will expand each into its own folder.
for entry in "$search_dir"/*.zip
do
  unzip $entry
done
