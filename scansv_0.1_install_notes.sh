#!/bin/bash

# 2019-05-09


#######################################################################
# SUCCESSFUL INSTALL and TESTED 
#######################################################################



# ScanSV
# Rendong Yang's ScanSV software
# Software was email to Todd Knutson on 2019-05-08 via zip file.





MODULE_NAME=scansv
VERSION=0.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



cp -a /home/lmnp/knut0297/software/resources/local_software_src/ScanSV.tar.gz .

tar -xzvf ScanSV.tar.gz




# The python script requires some python packages
# python2
# pysam
# numpy

module load numpy
module load pysam

/panfs/roc/soft/modulefiles.lab/pysam/0.6:
prepend-path    PATH /soft/pysam/0.6/bin
prepend-path    PYTHONPATH /soft/pysam/0.6/lib64/python2.6/site-packages

/panfs/roc/soft/modulefiles.lab/pysam/0.6:
prepend-path    PATH /soft/pysam/0.6/bin
prepend-path    PYTHONPATH /soft/pysam/0.6/lib64/python2.6/site-packages



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
        puts stderr "\tThis module adds scansv executable to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/ScanSV"
module load python2/2.7.15_anaconda


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




