#!/bin/bash
# 2018-04-11

# samtools ver 1.8
# Samtools is a suite of programs for interacting with high-throughput sequencing data. 



# Links:
# http://www.htslib.org
# http://www.htslib.org/download/



MODULE_NAME=samtools
VERSION=1.8
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://github.com/samtools/samtools/releases/download/1.8/samtools-1.8.tar.bz2
tar -xjf samtools-1.8.tar.bz2


cd samtools-1.8


module load xz-utils/5.2.3_gcc7.2.0
module load bzip2/1.0.6-gnu6.1.0_PIC
module load gcc/7.2.0

./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION

make
make install





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
        puts stderr "\tThis module adds samtools 1.8 to your path."
}


# Update the necessary shell environment variables to make the software work


module		 load xz-utils/5.2.3_gcc7.2.0
module		 load bzip2/1.0.6-gnu6.1.0_PIC
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"
prepend-path MANPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/share/man"




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







