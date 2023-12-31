#!/bin/bash

# 2019-07-09


#######################################################################
# Works!
#######################################################################






MODULE_NAME=R
VERSION=3.6.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



# Get the source code
wget https://mirror.las.iastate.edu/CRAN/src/base/R-3/R-3.6.1.tar.gz

tar xvf R-3.6.1.tar.gz
cd R-3.6.1

module load zlib/1.2.11_gcc7.2.0
module load bzip2/1.0.6-gnu7.2.0_PIC
module load pcre/8.42_gcc7.2.0
module load xz-utils/5.2.3_gcc7.2.0
module load curl/7.59.0_gcc7.2.0
module load libtiff/4.0.8
module load gcc/8.1.0

module load texlive/20131202
module load texinfo/6.5
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



./configure --prefix=${MODULES_DIR}/${MODULE_NAME}/${VERSION} --with-recommended-packages=yes --with-x --with-cairo --with-libpng --with-libtiff --with-jpeglib --enable-memory-profiling --enable-R-shlib --enable-R-static-lib CPPFLAGS="-I/panfs/roc/msisoft/bzip2/1.0.6-gcc7.2.0/include/ -L/panfs/roc/msisoft/bzip2/1.0.6-gcc7.2.0/lib"






# R is now configured for x86_64-pc-linux-gnu
# 
#   Source directory:            .
#   Installation directory:      /home/lmnp/knut0297/software/modules/R/3.6.1
# 
#   C compiler:                  /panfs/roc/msisoft/gcc/8.1.0/bin/gcc  -g -O2
#   Fortran fixed-form compiler: /panfs/roc/msisoft/gcc/8.1.0/bin/gfortran -fno-optimize-sibling-calls -g -O2
# 
#   Default C++ compiler:        /panfs/roc/msisoft/gcc/8.1.0/bin/g++ -std=gnu++11  -g -O2
#   C++98 compiler:              /panfs/roc/msisoft/gcc/8.1.0/bin/g++ -std=gnu++98  -g -O2
#   C++11 compiler:              /panfs/roc/msisoft/gcc/8.1.0/bin/g++ -std=gnu++11  -g -O2
#   C++14 compiler:              /panfs/roc/msisoft/gcc/8.1.0/bin/g++ -std=gnu++14  -g -O2
#   C++17 compiler:              /panfs/roc/msisoft/gcc/8.1.0/bin/g++ -std=gnu++17  -g -O2
#   Fortran free-form compiler:  /panfs/roc/msisoft/gcc/8.1.0/bin/gfortran -fno-optimize-sibling-calls -g -O2
#   Obj-C compiler:              gcc -g -O2 -fobjc-exceptions
# 
#   Interfaces supported:        X11, tcltk
#   External libraries:          readline, curl
#   Additional capabilities:     PNG, JPEG, TIFF, NLS, cairo
#   Options enabled:             shared R library, shared BLAS, R profiling, memory profiling
# 
#   Capabilities skipped:        ICU
#   Options not enabled:
# 
#   Recommended packages:        yes
# 
# configure: WARNING: you cannot build info or HTML versions of the R manuals
# configure: WARNING: I could not determine a PDF viewer



# NOTE:
# When the above says "shared BLAS" is enabled, this means there is a default single BLAS
# library installed in the R location, that R uses, and other packages use. This is not
# an "external" BLAS that was specified during compilation. 
# https://cran.r-project.org/doc/manuals/r-patched/R-admin.html#BLAS



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
        puts stderr "\tThis module adds R 3.6.1 executable to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"



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
# Block permissions on base R package library dir
#######################################################################

# I do not want anyone (including myself) from writing to the basic R packages dir.
# Remove dir write permissions.
# This will cause R to prompt you to install a R library dir in your home dir.

chmod a-w $MODULES_DIR/$MODULE_NAME/$VERSION/lib64/R/library




