#!/bin/bash

# 2021-02-08


MODULE_NAME=xclock
VERSION=1.0.9
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION


module use /home/lmnp/knut0297/software/modulesfiles
module purge
module load gcc/8.2.0
module load xorg_util_macros/1.19.3
module load /home/lmnp/knut0297/software/modulesfiles/libxaw/1.0.13
module load /home/lmnp/knut0297/software/modulesfiles/libxkbfile/1.1.0

wget https://www.x.org/archive//individual/app/xclock-1.0.9.tar.gz
tar xvzf xclock-1.0.9.tar.gz


cd $MODULES_DIR/$MODULE_NAME/$VERSION/xclock-1.0.9

# NOTE: see resulting Makefile for details
# specify '--with-appdefaultdir' with configure, otherwise, it tries to install default files
# to a root-owned location: /usr/share/X11/app-defaults. Including this flag will specify
# that the defaults location should be inside the local install dir.
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/X11/app-defaults
./configure --with-appdefaultdir=$MODULES_DIR/$MODULE_NAME/$VERSION/build/share/X11/app-defaults --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build

make -j 6
make install





# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/bin

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
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory




