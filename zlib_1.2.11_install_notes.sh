#!/bin/bash

# 2020-08-23

# http://www.zlib.net



MODULE_NAME=zlib
VERSION=1.2.11
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



module purge
module load gcc/7.2.0


# Get the static binary for linux
wget http://www.zlib.net/zlib-1.2.11.tar.gz
tar xzvf zlib-1.2.11.tar.gz

cd zlib-1.2.11

./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION
make
make install








# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################


# Create a help message for the module
# e.g. 
# module help <module_name>

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds $MODULE_NAME $VERSION executable to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path    LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib
prepend-path    LD_RUN_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib
prepend-path    LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib
prepend-path    CPATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    CPLUS_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    FPATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    MANPATH $MODULES_DIR/$MODULE_NAME/$VERSION/share/man
prepend-path    PKG_CONFIG_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib/pkgconfig



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



