# This file needs commenting and documentation
# It makes the metadata file easier to view when making Shannon diversity boxplots with the R script
file = "metadata_shannon_test.tsv"
f = open(file,"r")
line = f.readline()
while(line):
        if(line.startswith("#q2:types")):
                pass
        else:
                line = line.replace("D0","0wk").rstrip()
                line = line.replace("-Post-Eng","")
                split_str = line.split("\t")
                print(
                        split_str[0] + "\t" +
                        split_str[1] + "\t" +
                        split_str[2] + "\t" +
                        split_str[1] + "_" + split_str[2] + "\t" +
                        split_str[3]
                )
        line = f.readline()
