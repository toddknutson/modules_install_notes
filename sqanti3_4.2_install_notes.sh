#!/bin/bash

# 2022-01-21



MODULE_NAME=sqanti3
VERSION=4.2
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module -- sqanti3
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://github.com/ConesaLab/SQANTI3/archive/refs/tags/v${VERSION}.tar.gz
tar -xvzf v${VERSION}.tar.gz
cd SQANTI3-${VERSION}


rm utilities/gtfToGenePred
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/gtfToGenePred -P utilities
chmod +x utilities/gtfToGenePred 



# ---------------------------------------------------------------------
# Get cDNA_Cupcake
# ---------------------------------------------------------------------



# Load the python version needed
module purge
module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10
# Activate venv
# If the "deactivate" function is present in env, then run "deactivate" func.
set | grep -q "deactivate ()" && deactivate
source $HOME/software/python_venvs/sqanti3/bin/activate




wget https://github.com/Magdoll/cDNA_Cupcake/archive/refs/tags/v28.0.0.tar.gz
tar -xvzf v28.0.0.tar.gz
cd cDNA_Cupcake-28.0.0






# Requires Cython==0.29.25 (not 3.0.0)
# Requires scipy==1.7.3 (not 1.8.x)


# Build the library (creates a new dir called "build")
python setup.py build
# This will install executables into the venv bin (/home/lmnp/knut0297/software/python_venvs/sqanti3/bin)
python setup.py install





# ---------------------------------------------------------------------
# IsoAnnotLite and tappAS
# ---------------------------------------------------------------------


# https://isoannot.tappas.org/isoannot-lite/

# Download supported tappAS genome annotation info
# http://app.tappas.org/resources/downloads/gffs/

mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/isoannotlite_tappas
cd $MODULES_DIR/$MODULE_NAME/$VERSION/isoannotlite_tappas


# Download the python script
wget https://isoannot.tappas.org/resources/downloads/IsoAnnotLite.zip
unzip -d "." IsoAnnotLite.zip
chmod +x IsoAnnotLite_v2.7.0_SQ3.py
sed -i '1i#!/usr/bin/env python3' IsoAnnotLite_v2.7.0_SQ3.py


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/isoannotlite_tappas/support_files
cd $MODULES_DIR/$MODULE_NAME/$VERSION/isoannotlite_tappas/support_files

wget http://app.tappas.org/resources/downloads/gffs/Homo_sapiens_GRCh38_Ensembl_86.zip
unzip -d "." Homo_sapiens_GRCh38_Ensembl_86.zip



# USAGE (with sqanti3_qc results):
# python IsoAnnotLite_v2.7.0_SQ3.py \
# -gff3 "Homo_sapiens_GRCh38_Ensembl_86.gff3" \
# -novel \
# -o ${SAMPLE}_isoannotlite \
# -stdout ${SAMPLE}_summary_results.txt \
# $OUT_DIR/$SAMPLE/sqanti3_qc/${SAMPLE}_corrected.gtf \
# $OUT_DIR/$SAMPLE/sqanti3_qc/${SAMPLE}_classification.txt \
# $OUT_DIR/$SAMPLE/sqanti3_qc/${SAMPLE}_junctions.txt 
# 








# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME





cat > $VERSION <<EOF
#%Module######################################################################

module load perl/5.26.1
module load perl/modules.centos7.5.26.1
module load kallisto/0.46.2
module load star/2.7.1a

module load /home/lmnp/knut0297/software/modulesfiles/R/4.0.3_openblas
module load /home/lmnp/knut0297/software/modulesfiles/samtools/1.12
module load /home/lmnp/knut0297/software/modulesfiles/minimap2/2.17
module load /home/lmnp/knut0297/software/modulesfiles/desalt/1.5.6
module load /home/lmnp/knut0297/software/modulesfiles/gmap/2021-12-17
module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10
module load /home/lmnp/knut0297/software/modulesfiles/gffread/0.11.8
module load /home/lmnp/knut0297/software/modulesfiles/pandoc/2.16.2

# Previous modules load various python related stuff that we do not want here
module unload python3/3.6.3_anaconda5.0.1
module unload /home/lmnp/knut0297/software/modulesfiles/umap-learn/0.3.9

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/SQANTI3-4.2"
append-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/SQANTI3-4.2/cDNA_Cupcake-28.0.0"
append-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/SQANTI3-4.2/cDNA_Cupcake-28.0.0/sequence"
append-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/SQANTI3-4.2/cDNA_Cupcake-28.0.0/sequence"

append-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/isoannotlite_tappas"
setenv ISOANNOT_SUPPORT_DIR "$MODULES_DIR/$MODULE_NAME/$VERSION/isoannotlite_tappas/support_files"


if [ module-info mode load ] {
    puts stderr "* To use the sqanti3 package, activate the python virtual environment: '. /home/lmnp/knut0297/software/python_venvs/sqanti3/bin/activate'"
    puts stderr "An environment variable: ISOANNOT_SUPPORT_DIR, has been set to: $MODULES_DIR/$MODULE_NAME/$VERSION/isoannotlite_tappas/support_files\nIsoAnnotLite can be run using custom tappAS human GFF provided here: ls \\\$ISOANNOT_SUPPORT_DIR"
}




EOF








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







