# dnanexus_swiss_army_SNP_bcftools_filter
This repository contains the commands executed by the swiss army knife app (v3.0.0) to format a VCF according to GeL specifications for SNP ID checks

## Input
The input files for this app includes a bash script(snp_bcftools*.sh) and compressed GVCF file(s) produced by Sentieon Fastq to VCF app (*markdup_Haplotyper.g.vcf.gz).

The app's "command line" input is used to execute the above bash script. This command is recorded in command_line_input.sh

## How the app works
snp_bcftools*.sh loops through all the GCVfs,creates an index, converts to vcf, keeps SNPs of interest,annotates header with kit name uncompresses them, annotates the header, only keeps SNPs with DP > 5 and decomposes the VCF using BCFtools (v1.9).

## Output
Filtered VCFs have a suffix of sites_present_reheader_filtered.vcf.gz The app's "output folder" argument can be used to output files to the expected directory.
