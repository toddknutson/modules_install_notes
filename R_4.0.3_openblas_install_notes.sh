#!/bin/bash

# 2021-01-12


#######################################################################
# Success!
#######################################################################

# Compiled on mangi login node


# This version of R will use an external BLAS and LPACK library, 
# specifically, the Open BLAS library. This will allow for much 
# faster (10-100x) matrix multiplication etc (PCA, WGCNA, TSNE, etc).



MODULE_NAME=R
VERSION=4.0.3_openblas
VERSION_SHORT=4.0.3
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION



# Get the source code
wget https://mirror.las.iastate.edu/CRAN/src/base/R-4/R-$VERSION_SHORT.tar.gz

tar xvf R-$VERSION_SHORT.tar.gz
cd $MODULES_DIR/$MODULE_NAME/$VERSION/R-$VERSION_SHORT


module purge
module load zlib/1.2.11_gcc7.2.0
module load bzip2/1.0.6-gnu7.2.0_PIC
module load pcre/8.42_gcc7.2.0
module load xz-utils/5.2.3_gcc7.2.0
module load curl/7.59.0_gcc7.2.0
module load libtiff/4.0.8
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/panfs/roc/msisoft/libtiff/4.0.8/lib/pkgconfig
module load gcc/8.1.0
module load udunits/2.2.27.6_gcc7.2.0
module load texlive/20131202
module load texinfo/6.5
module load java/openjdk-8_202
module load pcre2/10.34

# To get cario (headless X11) to work, try this instead:
# https://stackoverflow.com/questions/26263934/compile-r-with-cairo-support-without-x11
# Todd's personal module
# /home/lmnp/knut0297/software/modulesfiles
module load cairo/1.16.0
module load openblas/0.3.13
module load libgit2/1.1.0



export CC=$(which gcc)
export CXX=$(which g++)
export FC=$(which gfortran)
export F77=$FC


# https://stackoverflow.com/questions/46413691/r-make-install-of-3-4-1-on-unix-is-failing-test-reg-tests-1d
export TZ="America/Chicago"

export WITH_BLAS="-L/home/lmnp/knut0297/software/modules/openblas/0.3.13/build/lib -I/home/lmnp/knut0297/software/modules/openblas/0.3.13/build/include -lpthread -lm"

# ./configure --help

# If both static and shared libraries are found, the linker gives preference to linking with the shared library unless the -static option is used.
# https://gcc.gnu.org/onlinedocs/gcc/Link-Options.html

./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build \
--with-recommended-packages=yes \
--with-x --with-cairo --with-libpng --with-libtiff --with-jpeglib \
--enable-memory-profiling \
--enable-R-shlib \
--enable-R-static-lib \
--enable-BLAS-shlib \
--with-blas="$WITH_BLAS" \
--with-lapack \
CFLAGS="-mtune=native -O3" \
LDFLAGS="-Bdirect,--hash-style=both,-Wl,-O1" \
FFLAGS="-mtune=native -O3" \
CPPFLAGS="-mtune=native"


#CPPFLAGS="-mtune=native -I/panfs/roc/msisoft/bzip2/1.0.6-gcc7.2.0/include -L/panfs/roc/msisoft/bzip2/1.0.6-gcc7.2.0/lib"




# R is now configured for x86_64-pc-linux-gnu
# 
#   Source directory:            .
#   Installation directory:      /home/lmnp/knut0297/software/modules/R/4.0.3_openblas/build
# 
#   C compiler:                  /panfs/roc/msisoft/gcc/8.1.0/bin/gcc  -mtune=native -O3
#   Fortran fixed-form compiler: /panfs/roc/msisoft/gcc/8.1.0/bin/gfortran -fno-optimize-sibling-calls -mtune=native -O3
# 
#   Default C++ compiler:        /panfs/roc/msisoft/gcc/8.1.0/bin/g++ -std=gnu++11  -g -O2
#   C++14 compiler:              /panfs/roc/msisoft/gcc/8.1.0/bin/g++ -std=gnu++14  -g -O2
#   C++17 compiler:              /panfs/roc/msisoft/gcc/8.1.0/bin/g++ -std=gnu++17  -g -O2
#   C++20 compiler:              /panfs/roc/msisoft/gcc/8.1.0/bin/g++ -std=gnu++2a  -g -O2
#   Fortran free-form compiler:  /panfs/roc/msisoft/gcc/8.1.0/bin/gfortran -fno-optimize-sibling-calls -mtune=native -O3
#   Obj-C compiler:              gcc -g -O2 -fobjc-exceptions
# 
#   Interfaces supported:        X11, tcltk
#   External libraries:          pcre2, readline, BLAS(OpenBLAS), curl
#   Additional capabilities:     PNG, JPEG, TIFF, NLS, cairo, ICU
#   Options enabled:             shared R library, shared BLAS, R profiling, memory profiling
# 
#   Capabilities skipped:
#   Options not enabled:
# 
#   Recommended packages:        yes
  
  
  

# NOTE:
# By default, there is a single BLAS and LPACK library 
# provided with R, that R, and other packages, use when compiling code. This is not
# an "external" BLAS/LPACK that was specified during compilation. When the above 
# says "Options not enabled: shared BLAS", this means than an "external" BLAS is being used instead
# of the "shared BLAS" provided with the R installation. 
# https://cran.r-project.org/doc/manuals/r-patched/R-admin.html#BLAS



make all recommended -j 16
make check
make install







# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME

mkdir -p $HOME/R/knut0297_software_module/x86_64-pc-linux-gnu-library/$VERSION


cat > $VERSION <<EOM
#%Module######################################################################

# MSI modules
module load gcc/8.1.0
module load udunits/2.2.27.6_gcc7.2.0
module load pcre2/10.34
module load java/openjdk-8_202
module load texlive/20131202
module load texinfo/6.5
module load libtiff/4.0.8
prepend-path PKG_CONFIG_PATH /panfs/roc/msisoft/libtiff/4.0.8/lib/pkgconfig
module load zlib/1.2.11_gcc7.2.0
module load bzip2/1.0.6-gnu7.2.0_PIC
module load pcre/8.42_gcc7.2.0
module load xz-utils/5.2.3_gcc7.2.0
module load curl/7.59.0_gcc7.2.0

# Todd's modules
module load cairo/1.16.0
module load openblas/0.3.13
module load libgit2/1.1.0
module load libffi/3.3
module load libicu4c/58.2
module load libpng/1.6.34
module load magick/7.0.8-23
module load umap-learn/0.3.9
module load hdf5/1.8.13
setenv DOWNLOAD_STATIC_LIBV8 1

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path LD_LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib64"
prepend-path LD_LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib64/R/lib"
prepend-path PKG_CONFIG_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib64/pkgconfig"
prepend-path MANPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/share/man"
setenv OMP_NUM_THREADS 1


# Below, will set the user R lib to a version-specific dir, to allow
# other R packages to be compiled against the dynamic external BLAS -- instead
# of being intermixed with the non-external-BLAS modules.
# This external-BLAS-specific library can be confirmed by running 
# Sys.getenv("R_LIBS_USER") within R.
setenv R_LIBS_USER "$HOME/R/knut0297_software_module/x86_64-pc-linux-gnu-library/$VERSION"

EOM









# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<EOM
#%Module
set ModulesVersion "$VERSION"

EOM






# ---------------------------------------------------------------------
# Update permissions (if you want to share the module)
# ---------------------------------------------------------------------


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME -maxdepth 0 -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULESFILES_DIR/$MODULE_NAME -maxdepth 0 -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULESFILES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs,go-w

# Make all files readable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r,go-w
find $MODULESFILES_DIR/$MODULE1_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r,go-w

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx,go-w
# Note: there are no executable files in the modulesfiles directory








#######################################################################
# Block permissions on base R package library dir
#######################################################################

# I do not want anyone (including myself) from writing to the basic R packages dir.
# Remove dir write permissions.
# This will cause R to prompt you to install a R library dir in your home dir.

chmod a-w $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib64/R/library




