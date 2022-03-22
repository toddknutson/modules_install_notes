#!/bin/bash

# 2022-03-04


MODULE_NAME=xtrans
VERSION=1.4.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION



module purge
module load gcc/8.2.0
module load /home/lmnp/knut0297/software/modulesfiles/xorg_util_macros/1.19.3


wget https://www.x.org/releases/individual/lib/${MODULE_NAME}-${VERSION}.tar.gz
tar xvzf ${MODULE_NAME}-${VERSION}.tar.gz


cd $MODULES_DIR/$MODULE_NAME/$VERSION/${MODULE_NAME}-${VERSION}


./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build

make -j 12
make install





# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME



 
cat > $VERSION <<EOF
#%Module######################################################################

prepend-path INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/build/include/X11/Xtrans
prepend-path INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/aclocal
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include/X11/Xtrans
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/aclocal
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


# Make all files readable; directories readable and executable
chmod a+rxs $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
chmod a+rxs $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that were already executable for the user, readable and executable for all
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx







