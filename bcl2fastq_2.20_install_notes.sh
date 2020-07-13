#!/bin/bash
# 2018-05-16

# bcl2fastq2


# FAIL











# Links:
# https://support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software/downloads.html
# Data  generated with Illumina RTA 1.18.54 or later, can use bcl2fastq2 version 2.0


MODULE_NAME=bcl2fastq2
VERSION=2.20
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget ftp://webdata2:webdata2@ussd-ftp.illumina.com/downloads/software/bcl2fastq/bcl2fastq2-v2-20-0-tar.zip

unzip bcl2fastq2-v2-20-0-tar.zip
tar -xzvf bcl2fastq2-v2.20.0.422-Source.tar.gz


    export TMP=/tmp
    export SOURCE=${TMP}/bcl2fastq
    export BUILD=${TMP}/bcl2fastq2-v2.17.1.x-build
    export INSTALL_DIR=/usr/local/bcl2fastq2-v2.17.1.x

    mkdir ${BUILD}
    cd ${BUILD}
    ${SOURCE}/src/configure --prefix=${INSTALL_DIR}
    make
    make install
    
    

cd samtools-1.8


module load xz-utils/5.2.3_gcc7.2.0
#module load bzip2/1.0.6-gnu6.1.0_PIC
module load cmake/3.0.0
module load boost/1.54.0
module load gcc/4.7.0



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







