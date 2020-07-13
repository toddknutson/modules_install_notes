#!/bin/bash
# 2019-12-07


#######################################################################
# SUCCESSFUL INSTALL
#######################################################################



# This is a custom software pipeline developed by Todd Knutson
# This module is created and edited by Todd.


# The name "shotmeta" stands for shotgun metagenomics 


MODULE_NAME=shotmeta
VERSION=dev
MODULES_DIR=/home/lmnp/knut0297/software/develop/$MODULE_NAME
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR
cd $MODULES_DIR

# Develop the software in this dir


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
        puts stderr "\tThis module adds shotmeta to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR"




ENDOFMESSAGE







# ---------------------------------------------------------------------
# Update permissions (if you want to share the module)
# ---------------------------------------------------------------------


# Make all directories readable and executable
find $MODULES_DIR -type d -print0 | xargs -0 chmod a+rx
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx

# Make all files readable
find $MODULES_DIR -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory




