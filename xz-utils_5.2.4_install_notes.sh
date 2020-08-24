#!/bin/bash

# 2020-08-24

# https://tukaani.org/xz/
# https://noknow.info/it/os/install_xz_utils_from_source?lang=en#sec2-1



MODULE_NAME=xz-utils
VERSION=5.2.4
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



module purge
module load gcc/7.2.0



wget https://tukaani.org/xz/xz-5.2.4.tar.gz
tar xzvf xz-5.2.4.tar.gz

cd xz-5.2.4

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
prepend-path    PATH $MODULES_DIR/$MODULE_NAME/$VERSION/bin
prepend-path    LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib
prepend-path    LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib
prepend-path    INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    CPATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    CPLUS_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    FPATH $MODULES_DIR/$MODULE_NAME/$VERSION/include
prepend-path    PKG_CONFIG_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/lib/pkgconfig
prepend-path    MANPATH $MODULES_DIR/$MODULE_NAME/$VERSION/share/man



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



