#!/bin/bash

# 2021-02-08

# This library is needed for Xclock, part of the Xorg. 



MODULE_NAME=xorg_util_macros
VERSION=1.19.3
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


wget https://www.x.org/archive//individual/util/util-macros-1.19.3.tar.gz
tar xvzf util-macros-1.19.3.tar.gz


cd $MODULES_DIR/$MODULE_NAME/$VERSION/util-macros-1.19.3
./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build
make install







# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

prepend-path INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/aclocal
prepend-path CPATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/aclocal
prepend-path C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/aclocal
prepend-path CPLUS_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/aclocal
prepend-path FPATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/aclocal
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/aclocal
prepend-path LD_RUN_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/aclocal
prepend-path LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/aclocal
prepend-path PKG_CONFIG_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/pkgconfig
setenv ACLOCAL "aclocal -I $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/aclocal"

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

