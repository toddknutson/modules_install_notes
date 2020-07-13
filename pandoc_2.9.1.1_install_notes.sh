#!/bin/bash
# 2020-02-06


#######################################################################
# SUCCESS
#######################################################################



MODULE_NAME=pandoc
VERSION=2.9.1.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################

# If dir already exists, delete it
if [ -d "$MODULES_DIR/$MODULE_NAME/$VERSION" ]; then rm -Rf $MODULES_DIR/$MODULE_NAME/$VERSION; fi

mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# Use the pre-compiled versions
wget https://github.com/jgm/pandoc/releases/download/2.9.1.1/pandoc-2.9.1.1-linux-amd64.tar.gz

tar xvf pandoc-2.9.1.1-linux-amd64.tar.gz


cd pandoc-2.9.1.1/bin

./pandoc --version
# pandoc 2.9.1.1
# Compiled with pandoc-types 1.20, texmath 0.12, skylighting 0.8.3
# Default user data directory: /home/lmnp/knut0297/.local/share/pandoc or /home/lmnp/knut0297/.pandoc
# Copyright (C) 2006-2019 John MacFarlane
# Web:  https://pandoc.org
# This is free software; see the source for copying conditions.
# There is no warranty, not even for merchantability or fitness
# for a particular purpose.








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
        puts stderr "\tThis module adds pandoc to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/pandoc-2.9.1.1/bin"




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




