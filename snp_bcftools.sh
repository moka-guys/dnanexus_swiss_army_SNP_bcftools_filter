#get reference genome
for fasta in *GRCh38_full_analysis_set_plus_decoy_hla.fa.gz; do
    #unzip it 
	gunzip $fasta
	fasta_file=*GRCh38_full_analysis_set_plus_decoy_hla.fa
done
echo $fasta_file

#get BED file 
bedfile=*.bed 
echo $bedfile

#get header 
header_file=*header.csv
echo $header_file

#process vcf file 
for vcf in *.g.vcf.gz; do
    vcf_filename="$(echo $vcf | cut -d '.' -f1)"
    echo $vcf_filename
    #save all sample LIMS ID in a text file
    lims_id="$(echo $vcf_filename | cut -d '_' -f3)"
    echo $lims_id > $vcf_filename.dnanumber.txt
    #create an index for vcf 
    echo "creating index for vcf"
    tabix -p vcf $vcf
    #conert gvcf to vcf
    #-R region of interest -f fasta_file 
    #-0z specifies output format z=zipped
    echo "convert to vcf"
    bcftools convert --gvcf2vcf -R $bedfile -f $fasta_file -Oz -o $vcf_filename.sites.vcf.gz $vcf
    echo "remove unused alleles"
    #--trim-alt-alleles: trim alternate alleles not seen in subset
    #-0z specifies output format z=zipped
    bcftools view --trim-alt-alleles -Oz -o $vcf_filename.sites_present.vcf.gz $vcf_filename.sites.vcf.gz
    echo "annotating header"
    #annotate header with kit name Nimagen SNP Genotyping v2.0
    #-0z specifies output format z=zipped
    #-h header file contains single line: source=Nimagenkit_v2
    bcftools annotate -h $header_file -Oz -o $vcf_filename.sites_present_reheader.vcf.gz $vcf_filename.sites_present.vcf.gz
    echo "filter"
    #-i only keep SNPs with DP (within format column) > 5
    #-m x The "x" mode resets filters of sites which pass to "PASS"
    #-0z specifies output format z=zipped
    bcftools filter -i 'FMT/DP>5' -m x -Oz -o $vcf_filename.sites_present_reheader_filtered.vcf.gz $vcf_filename.sites_present_reheader.vcf.gz
    #decompose vcf; split biallelic regions to seperate lines. 
    #split multiallelic sites into biallelic records (-)
    #-0z specifies output format z=zipped
    echo "change sample name to DNA number"
    #change sample name in the VCF to dnanumber 
    #-s = DNA number saved in text file 
    bcftools reheader -s $vcf_filename.dnanumber.txt -o $vcf_filename.sites_present_renamed_reheader_filtered.vcf.gz $vcf_filename.sites_present_reheader_filtered.vcf.gz
    echo "normalise and decompose"
    #-m - = split multiallelic sites into biallelic records
    #-Ov = output type unzipped vcf
    bcftools norm -m - -Ov -o $vcf_filename.sites_present_reheader_filtered_normalised.vcf $vcf_filename.sites_present_renamed_reheader_filtered.vcf.gz
done
