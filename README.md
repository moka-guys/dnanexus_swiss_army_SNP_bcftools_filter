# dnanexus_swiss_army_SNP_bcftools_filter_v1.0.1
This repository contains the commands executed by the swiss army knife app (v3.0.0) to format a VCF according to GeL specifications for SNP ID checks

## Inputs
Required input files for the swiss army knife app:
* A gzipped reference genome (eg GRCh38_full_analysis_set_plus_decoy_hla.fa.gz)
* A bash script (snp_bcftools*.sh) from this repo that describes the processing required.
* Compressed GVCF file(s) produced by Sentieon Fastq to VCF app (*markdup_Haplotyper.g.vcf.gz).
* SNP header.csv - a template header to insert into the vcf.
* BED file - used to restrict the sites to the expected SNPs (when converting gVCF to VCF)

The app's "command line" input is used to execute the above bash script. This command is recorded in command_line_input.sh

## How the app works
snp_bcftools*.sh loops through each gVCFs and does the following:
- Captures the sample IDs into a text file.
- creates index for VCF (tabix)
- converts gVCF to VCF (bcftools convert)
- trims alt alleles (bcftools view)
- annotates VCF header with source=Nimagenkit_v2 (bcftools annotate)
- filters VCF keeps SNPs with DP (within format column) > 5 (bcftools filter)
- changes sample name in the VCF to DNA number (bcftools reheader)
- normalises, decomposes and uncompresses the VCF (bcftools norm)

## Output
A gzipped VCF is created at each of the above steps, except the final step wich is not gzipped.
All gzipped VCFs are intermediate files and are output to an intermediate_files subfolder.
Files are output to the output location specified when setting off the app (usually /output).
