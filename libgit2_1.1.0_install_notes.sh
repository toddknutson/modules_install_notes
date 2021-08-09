#!/bin/bash

# 2021-01-13


#######################################################################
# 
#######################################################################

# https://libgit2.org

# This library is needed for the R package "devtools"
# https://github.com/bigdatagenomics/adam/issues/2085
# https://devtools.r-lib.org



MODULE_NAME=libgit2
VERSION=1.1.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://github.com/libgit2/libgit2/releases/download/v$VERSION/libgit2-$VERSION.tar.gz

tar xvzf libgit2-$VERSION.tar.gz
cd $MODULES_DIR/$MODULE_NAME/$VERSION/libgit2-$VERSION



module purge
module load cmake/3.12.3
module load gcc/7.2.0



cmake -DCMAKE_INSTALL_PREFIX=$MODULES_DIR/$MODULE_NAME/$VERSION/build -DCMAKE_CXX_COMPILER=$(which g++) -DCMAKE_C_COMPILER=$(which gcc)
make CXX=$(which g++) CC=$(which gcc)
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
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib64
prepend-path LD_RUN_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib64
prepend-path LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib64
prepend-path PKG_CONFIG_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib64/pkgconfig

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




