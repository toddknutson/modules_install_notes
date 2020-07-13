#!/bin/bash
# 2018-05-29

# vcflib

# Links:
# https://github.com/vcflib/vcflib



MODULE_NAME=vcflib
VERSION=20180529
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


git clone --recursive https://github.com/vcflib/vcflib
cd vcflib


module load gcc/7.2.0
module load liblzma/5.2.2

make






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
        puts stderr "\tThis module adds vcflib to your path."
}


# Update the necessary shell environment variables to make the software work
module load /panfs/roc/soft/modulefiles.legacy/modulefiles.common/gcc/4.8.2
module load liblzma/5.2.2
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/vcflib/bin
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/vcflib/fastahack
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/vcflib/filevercmp
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/vcflib/fsom
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/vcflib/intervaltree
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/vcflib/multichoose
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/vcflib/smithwaterman
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/vcflib/tabixpp



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
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory







