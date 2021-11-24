#!/bin/bash

# vcf2maf


# https://useast.ensembl.org/info/docs/tools/vep/script/vep_download.html

MODULE_NAME=vcf2maf
VERSION=1.6.21
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



git clone --recursive -b "v${VERSION}" https://github.com/mskcc/vcf2maf.git
tar czf vcf2maf.tar.gz vcf2maf
cd vcf2maf
git reset --hard

 
# Update permissions
find . -type f -name "*.pl" -print0 | xargs -0 -I{} chmod u+x {}



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME





cat > $VERSION <<EOF
#%Module######################################################################

module load perl/5.26.1
module load /home/lmnp/knut0297/software/modulesfiles/samtools/1.12
module load /home/lmnp/knut0297/software/modulesfiles/htslib/1.12
module load /home/lmnp/knut0297/software/modulesfiles/vep/104.3
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/vcf2maf"

# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "To run vcf2maf.pl with Variant Effector Predictor, try using this option: vcf2maf.pl --vep-data \\\$VEP_CACHE"
}


EOF


# USAGE
# module load /home/lmnp/knut0297/software/modulesfiles/vcf2maf/1.6.21
# vcf2maf.pl --man





# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<EOF
#%Module
set ModulesVersion "$VERSION"

EOF







# ---------------------------------------------------------------------
# Update permissions (if you want to share the module)
# ---------------------------------------------------------------------


# Make all files readable; directories readable and executable
chmod a+rxs $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
chmod a+rxs $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that were already executable for the user, readable and executable for all
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx






# ---------------------------------------------------------------------
# Test the installation
# ---------------------------------------------------------------------

mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/vcf2maf_test
cd $MODULES_DIR/$MODULE_NAME/$VERSION/vcf2maf_test

wget https://raw.githubusercontent.com/Ensembl/ensembl-vep/release/104/examples/homo_sapiens_GRCh37.vcf

module purge
module load /home/lmnp/knut0297/software/modulesfiles/vcf2maf/1.6.21



vcf2maf.pl --input-vcf homo_sapiens_GRCh37.vcf \
--output-maf homo_sapiens_GRCh37.maf \
--tmp-dir "." \
--vep-path "$(dirname $(which vep))" \
--vep-data $VEP_CACHE \
--vep-forks $THREADS \
--species "homo_sapiens" \
--ref-fasta "$VEP_CACHE/homo_sapiens/104_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz" \
--ncbi-build "GRCh37"






