#!/bin/bash

# 2021-02-19

# This library is needed for MuPDF.
# http://freeglut.sourceforge.net/docs/install.php


MODULE_NAME=freeglut
VERSION=3.2.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION


module use /home/lmnp/knut0297/software/modulesfiles
module purge
module load /home/lmnp/knut0297/software/modulesfiles/cmake/3.12.3
module load gcc/7.2.0

wget https://sourceforge.net/projects/freeglut/files/freeglut/3.2.1/freeglut-3.2.1.tar.gz
tar xvzf freeglut-3.2.1.tar.gz


cd $MODULES_DIR/$MODULE_NAME/$VERSION/freeglut-3.2.1


cmake -DCMAKE_INSTALL_PREFIX=$MODULES_DIR/$MODULE_NAME/$VERSION/build -DCMAKE_CXX_COMPILER=$(which g++) -DCMAKE_C_COMPILER=$(which gcc)
make -j 6 CXX=$(which g++) CC=$(which gcc)
make install




# 
# Install the project...
# -- Install configuration: ""
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/lib64/libglut.so.3.11.0
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/lib64/libglut.so.3
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/lib64/libglut.so
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/lib64/libglut.a
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/include/GL/freeglut.h
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/include/GL/freeglut_ucall.h
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/include/GL/freeglut_ext.h
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/include/GL/freeglut_std.h
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/include/GL/glut.h
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/lib64/pkgconfig/glut.pc
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/lib64/cmake/FreeGLUT/FreeGLUTTargets.cmake
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/lib64/cmake/FreeGLUT/FreeGLUTTargets-noconfig.cmake
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/lib64/cmake/FreeGLUT/FreeGLUTConfig.cmake
# -- Installing: /home/lmnp/knut0297/software/modules/freeglut/3.2.1/build/lib64/cmake/FreeGLUT/FreeGLUTConfigVersion.cmake
# 
# 






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


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory

