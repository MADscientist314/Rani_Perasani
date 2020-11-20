# Download SNPEFF
# Download using wget
$ wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip

# If you prefer to use 'curl' instead of 'wget', you can type:
#     curl -L https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip > snpEff_latest_core.zip

# Install
$ unzip snpEff_latest_core.zip

#Annotate using SnpEff

snpEff -v -stats ex1.html GRCh37.75 Rani_Perasani/uma_example.txt > Rani_Perasani/uma.ann.vcf
 java -Xmx8g -jar snpEff.jar GRCh37.75 examples/test.chr22.vcf > test.chr22.ann.vcf


snpEff -v -stats ex1.html GRCh37.75 Rani_Perasani/uma_example.txt > Rani_Perasani/uma.ann.vcf