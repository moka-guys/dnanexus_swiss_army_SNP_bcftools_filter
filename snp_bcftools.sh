#get reference genome
for fasta in *GRCh38_full_analysis_set_plus_decoy_hla.fa.gz; do
    #unzip it 
	gunzip $fasta
	fasta_file=*GRCh38_full_analysis_set_plus_decoy_hla.fa
done
echo $fasta_file

#get BED file 
bedfile=*newkit_bedfile_b38.bed 
echo $bedfile

#get header 
header_file=*header.csv
echo $header_file

#process vcf file 
for vcf in *.g.vcf.gz; do
    vcf_filename="$(echo $vcf | cut -d '.' -f1)"
    echo $vcf_filename
    #create an index for vcf 
    echo "creating index for vcf"
    tabix -p vcf $vcf
    #conert gvcf to vcf
    #-R region of interest -f fasta_file 
    echo "convert to vcf"
    bcftools convert --gvcf2vcf -R $bedfile -f $fasta_file -Oz -o $vcf_filename.sites.vcf.gz $vcf
    echo "remove unused alleles"
    #only keep SNPs of interest
    bcftools view --trim-alt-alleles -Oz -o $vcf_filename.sites_present.vcf.gz $vcf_filename.sites.vcf.gz
    echo "annotating header"
    #annotate header with kit name Nimagen SNP Genotyping v2.0
    bcftools annotate -h $header_file -Oz -o $vcf_filename.sites_present_reheader.vcf.gz $vcf_filename.sites_present.vcf.gz
    echo "filter"
    #Only keep SNPs with read depth more than 5
    #-m sets filter column to pass
    bcftools filter -i 'FMT/DP>5' -m x -Oz -o $vcf_filename.sites_present_reheader_filtered.vcf.gz $vcf_filename.sites_present_reheader.vcf.gz
    #decompose vcf; split biallelic regions to seperate lines. 
    echo "normalise and decompose"
    bcftools norm -m - -Oz -o $vcf_filename.sites_present_reheader_filtered_normalised.vcf.gz $vcf_filename.sites_present_reheader_filtered.vcf.gz
    #zcat $vcf_filename.sites_present_reheader_filtered_normalised.vcf.gz
done
