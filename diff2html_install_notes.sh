#!/bin/bash

# 2021-01-21


MODULE_NAME=diff2html
VERSION=5.1.2
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


module use /home/lmnp/knut0297/software/modulesfiles
module purge
module load node/14.15.4


# Install the library using npm (part of node.js)
# https://nodejs.org/en/knowledge/getting-started/npm/what-is-npm
# When you have a node project with a package.json file, you can run npm install from the 
# project root and npm will install all the dependencies listed in the package.json. 
# This makes installing a Node.js project from a git repo much easier!

# https://stackoverflow.com/a/32883387/2367748
# npm install --prefix $MODULES_DIR/$MODULE_NAME/$VERSION/build -g ./$VERSION.tar.gz


# INSTALL modules
npm install -g diff2html-cli@5.1.2

echo "NOTE: These are installed in the node module dir -- not prefixed here" > note




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

module load node/14.15.4

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


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME -maxdepth 0 -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULESFILES_DIR/$MODULE_NAME -maxdepth 0 -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULESFILES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs,go-w

# Make all files readable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r,go-w
find $MODULESFILES_DIR/$MODULE1_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r,go-w

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx,go-w
# Note: there are no executable files in the modulesfiles directory


