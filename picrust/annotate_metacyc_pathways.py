# Source file for Metacyc annotations: https://github.com/picrust/picrust2/blob/master/picrust2/default_files/description_mapfiles/metacyc_pathways_info.txt.gz

metacyc_pwys = "metacyc_pathways_info.txt"
picrust_res = "path_abun_modified.res"

f = open(metacyc_pwys,"r")
line = f.readline().rstrip()
pathway_annotations = {}
while(line):
	annot = line.split('\t')	
	pwy_abbrev = annot[0]
	pwy_long = annot[1]
	if pwy_abbrev in pathway_annotations.keys():
		die("duplicate...")
	else:
		pathway_annotations[pwy_abbrev]=pwy_long
	line = f.readline().rstrip()
f.close()

f = open(picrust_res,"r")
line = f.readline().rstrip()
while(line):
	tokens = line.split("\t")
	pwy_abbrev = tokens[0]
	pwy_lda = tokens[1]
	pwy_group = tokens[2]
	if pwy_abbrev in pathway_annotations.keys():
		print(pwy_abbrev+"\t"+pathway_annotations[pwy_abbrev]+"\t"+pwy_lda+"\t"+pwy_group+"\t"+"https://metacyc.org/META/NEW-IMAGE?type=PATHWAY&object="+pwy_abbrev)
	else:
		pwy_abbrev_dashed = pwy_abbrev.replace("_","-")
		if pwy_abbrev_dashed in pathway_annotations.keys():
			print(pwy_abbrev+"\t"+pathway_annotations[pwy_abbrev_dashed]+"\t"+pwy_lda+"\t"+pwy_group+"\t"+"https://metacyc.org/META/NEW-IMAGE?type=PATHWAY&object="+pwy_abbrev_dashed)
		else:		
			print(pwy_abbrev+"\t"+"No Metacyc mapping found"+"\t"+pwy_lda+"\t"+pwy_group)
	line = f.readline().rstrip()
f.close()
