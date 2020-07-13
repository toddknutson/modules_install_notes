#!/bin/bash

# 2019-05-22


#######################################################################
# SUCCESSFUL INSTALL and TESTED? -- NO -- FAILS WHNE TESTED ON ACTUAL VCFS, can get the helppage

#######################################################################


# blog post about SV VCF merging
# http://simpsonlab.github.io/2015/06/15/merging-sv-calls/
# https://github.com/ljdursi/mergevcf




# This is a fork of mergesv
# https://github.com/papaemmelab/mergeSVvcf



MODULE_NAME=mergesvvcf
VERSION=20190522
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################

rm -rf cd $MODULES_DIR/$MODULE_NAME/$VERSION

mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

# Helper info about installation
# https://kb.iu.edu/d/acey
# https://setuptools.readthedocs.io/en/latest/easy_install.html#use-the-user-option-and-customize-pythonuserbase


git clone --recursive git@github.com:papaemmelab/mergeSVvcf.git


cd mergeSVvcf

module purge
module load gcc/7.2.0
module load bzip2/1.0.6-gnu7.2.0_PIC
module load python3/3.6.3_anaconda5.0.1
module load samtools/1.9
module load bcftools/1.9
module load htslib/1.6
export PYTHONUSERBASE="$MODULES_DIR/$MODULE_NAME/$VERSION"

python setup.py install --user







# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<ENDOFMESSAGE
#%Module######################################################################


# Create a help message for the module
# e.g. 
# module help <module_name>

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds delly executable to your path."
}


# Update the necessary shell environment variables to make the software work
module load python3/3.7.1_anaconda
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/lib/python3.7/site-packages"
prepend-path PYTHONUSERBASE "$MODULES_DIR/$MODULE_NAME/$VERSION"

ENDOFMESSAGE


# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<ENDOFMESSAGE
#%Module
set ModulesVersion "$VERSION"

ENDOFMESSAGE






# ---------------------------------------------------------------------
# Update permissions (if you want to share the module)
# ---------------------------------------------------------------------


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory




