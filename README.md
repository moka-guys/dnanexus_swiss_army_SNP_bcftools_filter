# dnanexus_swiss_army_SNP_bcftools_filter
This repository contains the commands executed by the swiss army knife app (v3.0.0) to format a VCF according to GeL specifications for SNP ID checks

**Input** 
The input files for this app includes a bash script(snp_bcftools*.sh) and compressed GVCF file(s) produced by Sentieon Fastq to VCF app (*markdup_Haplotyper.g.vcf.gz).

The app's "command line" input is used to execute the above bash script. This command is recorded in command_line_input.sh

**How the app works**
snp_bcftools*.sh loops through all the GCVF files, uncompresses them, annotates the header, removes any unused alleles, removes any variants with DP < 5 and decomposes the GVCF using BCFtools (v1.9).

**Output**
Filtered VCF files are named filtered_normalised.vcf.gz The app's "output folder" argument can be used to output files to the expected directory.
