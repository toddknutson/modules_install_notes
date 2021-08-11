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
module load /home/lmnp/knut0297/software/modulesfiles/node/14.15.4




# https://github.com/rtfpessoa/diff2html-cli/releases
# Downloading release ver 5.1.2 (commit: c8967a8)

# The --global-style argument will cause npm to install the package into your local 
# node_modules folder with the same layout it uses with the global node_modules folder. 
# Only your direct dependencies will show in node_modules and everything they depend on 
# will be flattened in their node_modules folders. This obviously will eliminate some deduping.


cd $MODULES_DIR/$MODULE_NAME/$VERSION
npm install --global-style diff2html-cli@5.1.2





# 
# 
# # Install the library using npm (part of node.js)
# # https://nodejs.org/en/knowledge/getting-started/npm/what-is-npm
# # When you have a node project with a package.json file, you can run npm install from the 
# # project root and npm will install all the dependencies listed in the package.json. 
# # This makes installing a Node.js project from a git repo much easier!
# 
# # https://stackoverflow.com/a/32883387/2367748
# # npm install --prefix $MODULES_DIR/$MODULE_NAME/$VERSION/build -g ./$VERSION.tar.gz
# 
# 
# # INSTALL modules
# # commit c8967a8
# # https://github.com/rtfpessoa/diff2html-cli/releases
# npm install -g diff2html-cli@5.1.2
# 
# echo "NOTE: These are installed in the node module dir -- not prefixed here" > note




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

module load /home/lmnp/knut0297/software/modulesfiles/node/14.15.4
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/node_modules/.bin


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


