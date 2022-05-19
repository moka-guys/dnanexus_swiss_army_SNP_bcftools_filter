# dnanexus_swiss_army_SNP_bcftools_filter_v1.0.2
This repository contains the commands executed by the swiss army knife app (v3.0.0) to format a VCF according to GeL specifications for SNP ID checks

## Inputs
Required input files for the swiss army knife app:
* A gzipped reference genome (eg GRCh38_full_analysis_set_plus_decoy_hla.fa.gz)
* A bash script (snp_bcftools*.sh) from this repo that describes the processing required.
* Compressed GVCF file produced by Sentieon Fastq to VCF app (*markdup_Haplotyper.g.vcf.gz).
* SNP header.csv - a template header to insert into the vcf.
* BED file - used to restrict the sites to the expected SNPs (when converting gVCF to VCF)

The app's "command line" input is used to execute the above bash script. This command is recorded in command_line_input.sh

## How the app works
snp_bcftools*.sh looks for any gVCFs in the input and does the following:
- Captures the sample IDs into a text file.
- creates index for VCF (tabix)
- converts gVCF to VCF (bcftools convert)
- trims alt alleles (bcftools view)
- annotates VCF header with source=Nimagenkit_v2 (bcftools annotate)
- filters VCF keeps SNPs with DP (within format column) > 5 (bcftools filter)
- changes sample name in the VCF to DNA number (bcftools reheader)
- normalises, decomposes and uncompresses the VCF (bcftools norm)
- bcftools stats to produce a MultiQC friendly stats file, including a count of variants present.

Note that whilst the app is set up to work on multiple gVCFs in fact it will fail if attempting to process more than one.
## Output
A gzipped VCF is created at each of the above steps, except the final VCF which is not gzipped.
All gzipped VCFs are intermediate files and are output to a subfolder (/output/intermediate_files).
The stats file isoutput to /QC
The final VCF (*sites_present_reheader_filtered_normalised.vcf) is output to /output
