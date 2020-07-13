#!/bin/bash
# 2018-08-24

# zip

# ---------------------------------------------------------------------
# CURRENT MODULE STATUS
# ---------------------------------------------------------------------

# 2018-08-24, installed and working, except manpage is not working



# ---------------------------------------------------------------------
# Documentation
# ---------------------------------------------------------------------


# Links:
# https://sourceforge.net/projects/infozip/files/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz
# https://sourceforge.net/projects/infozip/files/Zip%203.x%20%28latest%29/3.0/zip30.tar.gz



# ---------------------------------------------------------------------
# Variables
# ---------------------------------------------------------------------


MODULE_NAME=zip
VERSION=3.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

wget https://sourceforge.net/projects/infozip/files/Zip%203.x%20%28latest%29/3.0/zip30.tar.gz
wget https://sourceforge.net/projects/infozip/files/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz


tar -xzvf unzip60.tar.gz
tar -xzvf zip30.tar.gz


cd zip30
make -f unix/Makefile generic_gcc
mkdir bin
find . -maxdepth 1 -executable -type f -print0 | xargs -0 -I {} mv {} bin/


cd $MODULES_DIR/$MODULE_NAME/$VERSION
cd unzip60
make -f unix/Makefile generic
mkdir bin
find . -maxdepth 1 -executable -type f -print0 | xargs -0 -I {} mv {} bin/







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
        puts stderr "\tThis module adds zip to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/unzip60/bin"
prepend-path MANPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/unzip60/man"
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/zip30/bin"
prepend-path MANPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/zip30/man"



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







