#!/bin/bash
# 2021-02-22  


#######################################################################
# SUCCESSFUL INSTALL
#######################################################################



# This is a custom bash script forked and then slightly modified by Todd Knutson
# This module is created and edited by Todd.


# The name "ceph_url" indicates this tool will create a signed URL for data stored on MSI ceph.


MODULE_NAME=ceph_url
VERSION=dev
MODULES_DIR=/home/lmnp/knut0297/software/develop/$MODULE_NAME
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR
cd $MODULES_DIR

# Develop the software in this dir
# Push changes to github



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<ENDOFMESSAGE
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/scripts"




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




