#!/bin/bash

# 2019-06-18

# cairo

# Links:
# https://cairographics.org



MODULE_NAME=cairo
VERSION=1.16.0
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

module load gcc/7.2.0




wget https://cairographics.org/releases/pixman-0.38.4.tar.gz
tar -xzvf pixman-0.38.4.tar.gz
cd pixman-0.38.4
./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION
make
make install


export LD_LIBRARY_PATH=$MODULES_DIR/$MODULE_NAME/$VERSION/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$MODULES_DIR/$MODULE_NAME/$VERSION/include:$C_INCLUDE_PATH
export INCLUDE=$MODULES_DIR/$MODULE_NAME/$VERSION/include:$INCLUDE
export PKG_CONFIG_PATH="$MODULES_DIR/$MODULE_NAME/$VERSION/lib/pkgconfig"



cd $MODULES_DIR/$MODULE_NAME/$VERSION
wget https://cairographics.org/releases/cairo-1.16.0.tar.xz
tar -xJvf cairo-1.16.0.tar.xz
cd cairo-1.16.0
./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION

make
make check
make install






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
        puts stderr "\tThis module adds cairo and pixman to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/bin
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib
prepend-path C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/include
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
find $MODULES_DIR/$MODULE_NAME -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory







