#!/bin/bash
# 2019-01-02


#######################################################################
# SUCCESSFUL INSTALL
#######################################################################



# Image conversion software
# https://www.imagemagick.org/script/install-source.php





MODULE_NAME=magick
VERSION=7.0.8-23
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://imagemagick.org/download/ImageMagick-7.0.8-23.zip
unzip ImageMagick-7.0.8-23.zip
cd ImageMagick-7.0.8-23


module load gcc/8.1.0

./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION
make
make check
# Install binaries into the prefix above
make install




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<ENDOFMESSAGE
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"
prepend-path CPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/include"
prepend-path C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path LD_RUN_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib
prepend-path LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib
prepend-path PKG_CONFIG_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib/pkgconfig




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




