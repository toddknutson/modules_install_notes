#!/bin/bash

# 2018-05-31

# svaba
# structural variant caller

# Links:
https://github.com/walaj/svaba



MODULE_NAME=svaba
VERSION=1.1.0
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

# 2019-05-14
# 6 commits past 1.1.0 release
git clone --recursive git@github.com:walaj/svaba.git

# Make an archive
tar -cvzf svaba_1.1.0plus6commits.tar.gz svaba/


cd svaba
module load gcc/7.2.0
module load bzip2/1.0.6-gnu7.2.0_PIC




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
        puts stderr "\tThis module adds svaba to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/svaba/bin




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
find $MODULES_DIR/$MODULE_NAME -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory







