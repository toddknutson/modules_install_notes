#!/bin/bash

# 2021-01-21

# This is a node.js javascript library.
# I needed this for diff2html.


MODULE_NAME=node
VERSION=14.15.4
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

# https://nodejs.org/en/download/

wget https://nodejs.org/dist/v14.15.4/node-v14.15.4-linux-x64.tar.xz
tar Jxvf node-v14.15.4-linux-x64.tar.xz



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME



cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/node-v14.15.4-linux-x64/bin
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/node-v14.15.4-linux-x64/lib
prepend-path LD_RUN_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/node-v14.15.4-linux-x64/lib
prepend-path LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/node-v14.15.4-linux-x64/lib
prepend-path CPATH $MODULES_DIR/$MODULE_NAME/$VERSION/node-v14.15.4-linux-x64/include
prepend-path C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/node-v14.15.4-linux-x64/include
prepend-path CPLUS_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/node-v14.15.4-linux-x64/include
prepend-path INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/node-v14.15.4-linux-x64/include
prepend-path PKG_CONFIG_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/node-v14.15.4-linux-x64/lib/pkgconfig
prepend-path MANPATH $MODULES_DIR/$MODULE_NAME/$VERSION/node-v14.15.4-linux-x64/share/man
prepend-path MANPATH $MODULES_DIR/$MODULE_NAME/$VERSION/node-v14.15.4-linux-x64/lib/node_modules/npm/man

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

