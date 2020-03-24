for fasta in *.fa.gz; do
	gunzip $fasta
	ls
	fasta_file=*.fa
done
for header in *csv; do
	header_file=header
done
for bed in *bed; do
	bedfile=$bed
done
echo $fasta_file
echo $header_file
echo $bedfile
for vcf in *.g.vcf.gz; do
    vcf_filename="$(echo $vcf | cut -d '.' -f1)"
    echo $vcf_filename
    echo "creating index for vcf"
    tabix -p vcf $vcf
    echo "convert to vcf"
    bcftools convert --gvcf2vcf -R $bedfile -f $fasta_file -Oz -o $vcf_filename.sites.vcf.gz $vcf
    ls
    echo "remove unused alleles"
    bcftools view --trim-alt-alleles -Oz -o $vcf_filename.sites_present.vcf.gz $vcf_filename.sites.vcf.gz
    echo "annotating header"
    bcftools annotate -h $header -Oz -o $vcf_filename.sites_present_reheader.vcf.gz $vcf_filename.sites_present.vcf.gz
    echo "filter"
    bcftools filter -i 'FMT/DP>5' -m x -Oz -o $vcf_filename.sites_present_reheader_filtered.vcf.gz $vcf_filename.sites_present_reheader.vcf.gz
    echo "normalise and decompose"
    bcftools norm -m - -Oz -o $vcf_filename.sites_present_reheader_filtered_normalised.vcf.gz $vcf_filename.sites_present_reheader_filtered.vcf.gz
    #zcat $vcf_filename.sites_present_reheader_filtered_normalised.vcf.gz
done
