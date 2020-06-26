# dnanexus_swiss_army_SNP_bcftools_filter
This repository contains the commands executed by the swiss army knife app (v3.0.0) to format a VCF according to GeL specifications for SNP ID checks

## Input
The input files for this app includes a bash script(snp_bcftools*.sh) and compressed GVCF file(s) produced by Sentieon Fastq to VCF app (*markdup_Haplotyper.g.vcf.gz).

The app's "command line" input is used to execute the above bash script. This command is recorded in command_line_input.sh

## How the app works
snp_bcftools*.sh loops through each gCVFs and does the following:
- creates index for VCF (tabix)
- converts gVCF to VCF (bcftools convert)
- trims alt alleles (bcftools view)
- annotates VCF header with source=Nimagenkit_v2 (bcftools annotate)
- flters VCF keeps SNPs with DP (within format column) > 5 (bcftools filter)
- normalises and decomposes the VCF (bcftools norm)

## Output
Filtered VCFs have a suffix of sites_present_reheader_filtered.vcf.gz The output files are saved to / unless the output location is specified when setting off the app
