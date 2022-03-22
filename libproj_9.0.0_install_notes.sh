#!/bin/bash

# 2022-03-12

# If not a slurm job, set THREADS to 1
export THREADS=$([ ! -z ${SLURM_CPUS_PER_TASK+x} ] && echo ${SLURM_CPUS_PER_TASK} || echo 1)


MODULE_NAME=libproj
MODULE_NAME_SHORT=proj
VERSION=9.0.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/{cmake_,}build
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://download.osgeo.org/proj/${MODULE_NAME_SHORT}-${VERSION}.tar.gz
tar xvzf ${MODULE_NAME_SHORT}-${VERSION}.tar.gz

cd $MODULES_DIR/$MODULE_NAME/$VERSION/${MODULE_NAME_SHORT}-${VERSION}

module purge
module load gcc/7.2.0
module load /home/lmnp/knut0297/software/modulesfiles/cmake/3.21.1
module load /home/lmnp/knut0297/software/modulesfiles/sqlite/3.38.1



cmake \
-B $MODULES_DIR/$MODULE_NAME/$VERSION/cmake_build \
-S $MODULES_DIR/$MODULE_NAME/$VERSION/${MODULE_NAME_SHORT}-${VERSION} \
-DCMAKE_INSTALL_PREFIX=$MODULES_DIR/$MODULE_NAME/$VERSION/build \
-DCMAKE_CXX_COMPILER=$(which g++) \
-DCMAKE_C_COMPILER=$(which gcc) \
-DSQLITE3_INCLUDE_DIR=$MODULES_DIR/sqlite/3.38.1/build/include \
-DSQLITE3_LIBRARY=$MODULES_DIR/sqlite/3.38.1/build/lib/libsqlite3.so


cd $MODULES_DIR/$MODULE_NAME/$VERSION/cmake_build


make -j $THREADS 
make -j $THREADS install 

ctest -j $THREADS








# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME





cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
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






