#!/bin/bash

# 2021-02-08

# This library is needed for Xclock, part of the Xorg. 



MODULE_NAME=libxaw
VERSION=1.0.13
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

# This export should not be needed, if xorg_util_macros is loaded above
# export ACLOCAL='aclocal -I ~/software/modules/xorg_util_macros/1.19.3/build/share/aclocal'



wget https://github.com/freedesktop/xorg-libXaw/archive/libXaw-1.0.13.tar.gz
tar xvzf libXaw-1.0.13.tar.gz


cd $MODULES_DIR/$MODULE_NAME/$VERSION/xorg-libXaw-libXaw-1.0.13
./autogen.sh
./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build
make -j 8
make install








# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

prepend-path INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path CPATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path CPLUS_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path FPATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path LD_RUN_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path PKG_CONFIG_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/pkgconfig


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

