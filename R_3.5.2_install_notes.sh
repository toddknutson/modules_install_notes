#!/bin/bash

# 2019-07-09


#######################################################################
# Worked! 2019-07-10 - passed checks
#######################################################################



MODULE_NAME=R
VERSION=3.5.2
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



# Get the source code
wget https://mirror.las.iastate.edu/CRAN/src/base/R-3/R-3.5.2.tar.gz

tar xvf R-3.5.2.tar.gz
cd R-3.5.2

module load zlib/1.2.11_gcc7.2.0
module load bzip2/1.0.6-gnu7.2.0_PIC
module load pcre/8.42_gcc7.2.0
module load xz-utils/5.2.3_gcc7.2.0
module load curl/7.59.0_gcc7.2.0
module load libtiff/4.0.8
module load gcc/8.1.0


module load texlive/20131202
module load java/openjdk-8_202

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/panfs/roc/msisoft/libtiff/4.0.8/lib/pkgconfig

export CC=$(which gcc)
export CXX=$(which g++)
export FC=$(which gfortran)
export F77=$FC




# https://stackoverflow.com/questions/46413691/r-make-install-of-3-4-1-on-unix-is-failing-test-reg-tests-1d
export TZ="America/Chicago"


# Nick Dunn's config command for 3.5.0 (works for ver 3.6.0 too!):
# ./configure --enable-memory-profiling --enable-R-shlib --enable-R-static-lib --prefix=${MODULES_DIR}/${MODULE_NAME}/${VERSION} CPPFLAGS="-I/panfs/roc/msisoft/bzip2/1.0.6-gcc7.2.0/include/ -L/panfs/roc/msisoft/bzip2/1.0.6-gcc7.2.0/lib"


# To get cario (headless X11) to work, try this instead:
# https://stackoverflow.com/questions/26263934/compile-r-with-cairo-support-without-x11
# Todd's personal module
# /home/lmnp/knut0297/software/modulesfiles
module load /home/lmnp/knut0297/software/modulesfiles/cairo/1.16.0

./configure --prefix=${MODULES_DIR}/${MODULE_NAME}/${VERSION} --with-recommended-packages=yes --without-x --with-cairo --with-libpng --with-libtiff --with-jpeglib --enable-memory-profiling --enable-R-shlib --enable-R-static-lib CPPFLAGS="-I/panfs/roc/msisoft/bzip2/1.0.6-gcc7.2.0/include/ -L/panfs/roc/msisoft/bzip2/1.0.6-gcc7.2.0/lib"


make all recommended -j 6
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
        puts stderr "\tThis module adds R 3.5.2 executable to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"
module load mkl/2018/release


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
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory





#######################################################################
# Fix permission on package library dir
#######################################################################

# I do not want anyone (including myself) from writing to the basic R packages dir.
# Remove dir write permissions.
# This will cause R to prompt you to install a R library dir in your home dir.

chmod a-w $MODULES_DIR/$MODULE_NAME/$VERSION/lib64/R/library


