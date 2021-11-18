#!/bin/bash

# vcf2maf


# https://useast.ensembl.org/info/docs/tools/vep/script/vep_download.html

MODULE_NAME=bbtools
VERSION=38.94
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://sourceforge.net/projects/bbmap/files/BBMap_${VERSION}.tar.gz
tar -xvzf BBMap_${VERSION}.tar.gz





# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME





cat > $VERSION <<EOF
#%Module######################################################################

module load java/openjdk-11.0.2
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bbmap"


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




# ---------------------------------------------------------------------
# EXAMPLE usage
# ---------------------------------------------------------------------

# 
# bbduk.sh \
# in="R1.fastq" \
# in2="R2.fastq" \
# out="non_human_R1.fastq" \
# out2="non_human_R2.fastq" \
# ref="/panfs/roc/risdb_new/ensembl/main/homo_sapiens/GRCh38/seq/genome.fa" \
# stats="BBDuk_rRNA_Stats.txt" \
# k=25 \
# editdistance=1 \
# prealloc=t \
# threads="1" \
# -Xmx75g






