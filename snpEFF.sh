# Go to home dir
#cd ~


############################
# PIPELINE
# STEP 0: download the ref 
# install the deps, 
# and make the variables
############################

mkdir -p $PWD/gemini/tools/
mkdir-p $PWD/gemini/data/
# Setup the variables in the script
VCF=$PWD/uma_example
REF=$PWD/hg19.fa
THREADS=$(nproc)
tools=$PWD/gemini/tools/
data=$pwd/gemini/data/

############################
#Preferred Conda based install
############################
# install the necessary packagages
conda create -n uma -c bioconda vt snpeff pigz
conda activate uma
# GEMINI
wget https://github.com/arq5x/gemini/raw/master/gemini/scripts/gemini_install.py
python gemini_install.py $tools $data
PATH=$tools/bin:$data/anaconda/bin:$PATH

# compress and index the vcf file
pigz -k -v $VCF.vcf>$VCF.vcf.gz
tabix -p vcf $VCF.vcf.gz

#Download and unzip reference genome
rsync -avzP rsync://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/hg19.fa.gz $PWD
unpigz hg19.fa.gz;
echo "LOG: reference dataset successfully downloaded and extracted"

############################
# STEP 1 : vt Pre-processing
# Objective : Use vt to decompose and normalize the counts
############################

#A) Decomposing
#this step takes multiallelic variants and expands them into distinct variant records; 
# one record for each REF/ALT combination. 
vt decompose \
-s \
-o $VCF.decompose.vcf.gz \
$VCF.vcf.gz

echo "LOG: vt decomposition complete"

#B) Normalization
vt normalize \
-r $REF \
-o $VCF.norm.vcf.gz \
$VCF.decompose.vcf.gz 

echo "LOG: vt normalization complete"

############################
# STEP 2 : snpEff Annotation
# Objective : Use snpEff to Annotate the normalized vcf
############################

#Annotate using SnpEff
java -Xmx8g -jar $PWD/snpEff/snpEff.jar \
-v \
-stats uma_example.html \
hg19 \
$VCF.norm.vcf.gz >$VCF.ann.vcf.gz

echo "LOG: snpEff annotation complete"

#NOTE IF YOU RUN OUT OF MEMORY TRY IT THIS WAY

# java -Xmx8g -jar $PWD/snpEff/snpEff.jar \
# -v \
# -stats uma_example.html \
# hg19 \
# $VCF.norm.vcf.gz >$VCF.ann.vcf.gz

rm -rf ./snpEff

############################
# STEP 3 : GEMINI 
# Objective : downstream vcf analysis of vcf with Gemini
############################

# load the pre-processed VCF into GEMINI
gemini load --cores $THREADS -t snpEff -v $VCF.ann.vcf.gz uma.db

# Example query from the tutorial
gemini query \
-q "select chrom, start, end, ref, alt, (gts).(*) from variants" \
--gt-filter "gt_types.mom == HET and gt_types.dad == HET and gt_types.kid == HOM_ALT"
    

echo "LOG: Job complete"
########################################################

exit 00

############################
#Optional Source instalation
############################
# SnpEff
# Download latest version
# wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip
# Unzip file
# unzip snpEff_latest_core.zip
# If you prefer to use 'curl' instead of 'wget', you can type:
# curl -L https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip > snpEff_latest_core.zip
#Install
# unzip snpEff_latest_core.zip

#vt
#this will create a directory named vt in the directory you cloned the repository
# 1. git clone https://github.com/atks/vt.git  
#change directory to vt
# 2. cd vt 
#run make, note that compilers need to support the c++0x standard 
# 3. make 
#you can test the build
# 4. make test

#GEMINI
# wget https://github.com/arq5x/gemini/raw/master/gemini/scripts/gemini_install.py
# python gemini_install.py $tools $data
# PATH=$tools/bin:$data/anaconda/bin:$PATH