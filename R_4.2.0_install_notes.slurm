#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --time=4:00:00
#SBATCH --mem=120gb
#SBATCH --tmp=32gb
#SBATCH --error=%x.e%j
#SBATCH --output=%x.o%j
#SBATCH --export=NONE
#SBATCH --mail-type=ALL
#SBATCH --mail-user=knut0297@umn.edu
#SBATCH --partition=agsmall


#######################################################################
# Script preliminaries
#######################################################################

# Exit script immediately upon error
set -o errexit -o errtrace -o pipefail -o functrace


function trap_my_error {
    >&2 echo "ERROR: \"${BASH_COMMAND}\" command failed with exit code $? [$(date)]"
}

function trap_my_exit {
    echo "[$(date)] Script exit."
    # Print env variables
    declare -p
    # Print slurm job details
    if [ ! -z ${SLURM_JOB_ID+x} ]; then
        scontrol show job "${SLURM_JOB_ID}"
        sstat -j "${SLURM_JOB_ID}" --format=JobID,MaxRSS,MaxVMSize,NTasks,MaxDiskWrite,MaxDiskRead
    fi
}
# Execute these functions after any error (i.e. nonzero exit code) or 
# when exiting the script (i.e. with zero or nonzero exit code).
trap trap_my_error ERR
trap trap_my_exit EXIT


# If not a slurm job, set THREADS to 1
export THREADS=$([ ! -z ${SLURM_CPUS_PER_TASK+x} ] && echo ${SLURM_CPUS_PER_TASK} || echo 1)

echo "[$(date)] Script start."

#######################################################################
# Script
#######################################################################


# ---------------------------------------------------------------------
# Program info
# ---------------------------------------------------------------------

# 2022-05-02


# This version of R will use an external BLAS and LPACK library, 
# specifically, the Open BLAS library. This will allow for much 
# faster (10-100x) matrix multiplication etc (PCA, WGCNA, TSNE, etc).



MODULE_NAME=R
VERSION=4.2.0
VERSION_SHORT=4.2.0
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
module load gcc/7.2.0
module load /home/lmnp/knut0297/software/modulesfiles/zlib/1.2.11
module load /home/lmnp/knut0297/software/modulesfiles/bzip2/1.0.6
module load /home/lmnp/knut0297/software/modulesfiles/pcre2/10.39
module load /home/lmnp/knut0297/software/modulesfiles/xz-utils/5.2.4
module load curl/7.59.0_gcc7.2.0
module load /home/lmnp/knut0297/software/modulesfiles/libtiff/4.3.0
module load /home/lmnp/knut0297/software/modulesfiles/texinfo/6.8
module load /home/lmnp/knut0297/software/modulesfiles/cairo/1.16.0
module load /home/lmnp/knut0297/software/modulesfiles/pandoc/2.16.2
module load /home/lmnp/knut0297/software/modulesfiles/libgit2/1.1.0
module load /home/lmnp/knut0297/software/modulesfiles/libffi/3.3
module load /home/lmnp/knut0297/software/modulesfiles/libicu4c/58.2
module load /home/lmnp/knut0297/software/modulesfiles/libpng/1.6.34
module load /home/lmnp/knut0297/software/modulesfiles/hdf5/1.8.13
module load /home/lmnp/knut0297/software/modulesfiles/openblas/0.3.20
module load /home/lmnp/knut0297/software/modulesfiles/magick/7.0.8-23
module load /home/lmnp/knut0297/software/modulesfiles/libproj/9.0.0
module load /home/lmnp/knut0297/software/modulesfiles/gsl/2.7
module load /home/lmnp/knut0297/software/modulesfiles/libgeos/3.10.2
module load /home/lmnp/knut0297/software/modulesfiles/gdal/3.4.2
module load /home/lmnp/knut0297/software/modulesfiles/udunits/2.2.28
module load /home/lmnp/knut0297/software/modulesfiles/libsodium/1.0.18
module load /home/lmnp/knut0297/software/modulesfiles/fftw/3.3.10
module load /home/lmnp/knut0297/software/modulesfiles/cmake/3.21.1
module load texlive/20131202
module load java/openjdk-8_202


export CC=$(which gcc)
export CXX=$(which g++)
export FC=$(which gfortran)
export F77=$FC

# https://stackoverflow.com/questions/46413691/r-make-install-of-3-4-1-on-unix-is-failing-test-reg-tests-1d
export TZ="America/Chicago"


# Make sure these paths match the module loaded above
export WITH_BLAS="-L/home/lmnp/knut0297/software/modules/openblas/0.3.20/build/lib -I/home/lmnp/knut0297/software/modules/openblas/0.3.20/build/include -lpthread -lm -lopenblas"

# ./configure --help

# If both static and shared libraries are found, the linker gives preference to linking with the shared library unless the -static option is used.
# https://gcc.gnu.org/onlinedocs/gcc/Link-Options.html

# If libraries are found in LD_LIBRARY_PATH, they are prefered over libraries listed  in LDFLAGS


./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build \
--with-recommended-packages=yes \
--with-x \
--with-cairo \
--with-libpng \
--with-libtiff \
--with-jpeglib \
--enable-memory-profiling \
--enable-R-shlib \
--enable-BLAS-shlib \
--with-blas="$WITH_BLAS" \
--with-lapack \
CFLAGS="-mtune=native -O3" \
LDFLAGS="-Bdirect,--hash-style=both,-Wl,-O1" \
FFLAGS="-mtune=native -O3" \
CPPFLAGS="-mtune=native"

#--enable-R-static-lib \





# https://stackoverflow.com/a/8482308/2367748
# https://stackoverflow.com/a/28096196/2367748
# https://stackoverflow.com/a/6562437/2367748
# https://stackoverflow.com/a/25918509/2367748

# If you want to link against libraries paths (e.g. LIBDIR) in a "non-system" location, use this:
# -Wl,-rpath -Wl,LIBDIR

# -Wl,-rpath,dir1,-rpath,dir2
# -Wl,-rpath=dir1,-rpath=dir2
# 
# -Wl,-rpath,/path/to/foo -L/path/to/foo -lbaz
# 
# 
# /home/lmnp/knut0297/software/modules/zlib/1.2.11/lib
# /home/lmnp/knut0297/software/modules/zlib/1.2.11/include
# 
# /home/lmnp/knut0297/software/modules/bzip2/1.0.6/bin
# /home/lmnp/knut0297/software/modules/bzip2/1.0.6/include
# 
# /home/lmnp/knut0297/software/modules/pcre2/10.39/build/lib
# /home/lmnp/knut0297/software/modules/pcre2/10.39/build/include
# 
# /home/lmnp/knut0297/software/modules/xz-utils/5.2.4/lib
# /home/lmnp/knut0297/software/modules/xz-utils/5.2.4/include
# 
# /panfs/roc/msisoft/curl/7.59.0_gcc7.2.0/lib
# /panfs/roc/msisoft/curl/7.59.0_gcc7.2.0/include
# 
# 
# /home/lmnp/knut0297/software/modules/libtiff/4.3.0/build/lib
# /home/lmnp/knut0297/software/modules/libtiff/4.3.0/build/include
# 
# /home/lmnp/knut0297/software/modules/texinfo/6.8/build/lib
# 
# /home/lmnp/knut0297/software/modules/cairo/1.16.0/lib
# /home/lmnp/knut0297/software/modules/cairo/1.16.0/include
# 
# /home/lmnp/knut0297/software/modules/libgit2/1.1.0/build/lib64
# /home/lmnp/knut0297/software/modules/libgit2/1.1.0/build/include
# 
# 
# /home/lmnp/knut0297/software/modules/libffi/3.3/build/include
# /home/lmnp/knut0297/software/modules/libffi/3.3/build/lib
# /home/lmnp/knut0297/software/modules/libffi/3.3/build/lib64
# 
# /home/lmnp/knut0297/software/modules/libicu4c/58.2/build/include
# /home/lmnp/knut0297/software/modules/libicu4c/58.2/build/lib
# 
# 
# /home/lmnp/knut0297/software/modules/libpng/1.6.34/lib
# 
# /home/lmnp/knut0297/software/modules/hdf5/1.8.13/build/lib
# /home/lmnp/knut0297/software/modules/hdf5/1.8.13/build/include
# 
# /home/lmnp/knut0297/software/modules/openblas/0.3.20/build/lib
# /home/lmnp/knut0297/software/modules/openblas/0.3.20/build/include
# 
# /home/lmnp/knut0297/software/modules/magick/7.0.8-23/lib
# /home/lmnp/knut0297/software/modules/magick/7.0.8-23/include
# 
# 
# 
# /home/lmnp/knut0297/software/modules/libproj/9.0.0/build/lib64
# /home/lmnp/knut0297/software/modules/libproj/9.0.0/build/include
# 
# /home/lmnp/knut0297/software/modules/gsl/2.7/build/lib
# /home/lmnp/knut0297/software/modules/gsl/2.7/build/include
# 
# /home/lmnp/knut0297/software/modules/libgeos/3.10.2/build/lib64
# /home/lmnp/knut0297/software/modules/libgeos/3.10.2/build/include
# 
# /home/lmnp/knut0297/software/modules/gdal/3.4.2/build/lib
# /home/lmnp/knut0297/software/modules/gdal/3.4.2/build/include
# 
# /home/lmnp/knut0297/software/modules/udunits/2.2.28/build/lib
# /home/lmnp/knut0297/software/modules/udunits/2.2.28/build/include
# 
# 
# /panfs/roc/msisoft/java/openjdk-8_202/lib
# /panfs/roc/msisoft/java/openjdk-8_202/include
# 




# 
# R is now configured for x86_64-pc-linux-gnu
# 
#   Source directory:            .
#   Installation directory:      /home/lmnp/knut0297/software/modules/R/4.1.3_openblas/build
# 
#   C compiler:                  /panfs/roc/msisoft/gcc/7.2.0/bin/gcc  -mtune=native -O3
#   Fortran fixed-form compiler: /panfs/roc/msisoft/gcc/7.2.0/bin/gfortran -fno-optimize-sibling-calls -mtune=native -O3
# 
#   Default C++ compiler:        /panfs/roc/msisoft/gcc/7.2.0/bin/g++ -std=gnu++14  -g -O2
#   C++11 compiler:              /panfs/roc/msisoft/gcc/7.2.0/bin/g++ -std=gnu++11  -g -O2
#   C++14 compiler:              /panfs/roc/msisoft/gcc/7.2.0/bin/g++ -std=gnu++14  -g -O2
#   C++17 compiler:              /panfs/roc/msisoft/gcc/7.2.0/bin/g++ -std=gnu++17  -g -O2
#   C++20 compiler:
#   Fortran free-form compiler:  /panfs/roc/msisoft/gcc/7.2.0/bin/gfortran -fno-optimize-sibling-calls -mtune=native -O3
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
#   
  

# NOTE:
# By default, there is a single BLAS and LPACK library 
# provided with R, that R, and other packages, use when compiling code. This is not
# an "external" BLAS/LPACK that was specified during compilation. When the above 
# says "Options not enabled: shared BLAS", this means than an "external" BLAS is being used instead
# of the "shared BLAS" provided with the R installation. 
# https://cran.r-project.org/doc/manuals/r-patched/R-admin.html#BLAS



make -j $THREADS
make -j $THREADS install



# 
# 
# make install-tests
# cd $MODULES_DIR/$MODULE_NAME/$VERSION/R-$VERSION_SHORT/tests
# ../../build/bin/R CMD make -j $THREADS check
# # ../../build/bin/R CMD make -j $THREADS check-devel
# # ../../build/bin/R CMD make -j $THREADS check-recommended
# 
# # These tests fail for trivial reasons
# # https://stat.ethz.ch/pipermail/r-devel/2002-January/023874.html
#




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME





cat > $VERSION <<HEREDOC
#%Module######################################################################

module purge
module load gcc/7.2.0
module load /home/lmnp/knut0297/software/modulesfiles/zlib/1.2.11
module load /home/lmnp/knut0297/software/modulesfiles/bzip2/1.0.6
module load /home/lmnp/knut0297/software/modulesfiles/pcre2/10.39
module load /home/lmnp/knut0297/software/modulesfiles/xz-utils/5.2.4
module load curl/7.59.0_gcc7.2.0
module load /home/lmnp/knut0297/software/modulesfiles/libtiff/4.3.0
module load /home/lmnp/knut0297/software/modulesfiles/texinfo/6.8
module load /home/lmnp/knut0297/software/modulesfiles/cairo/1.16.0
module load /home/lmnp/knut0297/software/modulesfiles/pandoc/2.16.2
module load /home/lmnp/knut0297/software/modulesfiles/libgit2/1.1.0
module load /home/lmnp/knut0297/software/modulesfiles/libffi/3.3
module load /home/lmnp/knut0297/software/modulesfiles/libicu4c/58.2
module load /home/lmnp/knut0297/software/modulesfiles/libpng/1.6.34
module load /home/lmnp/knut0297/software/modulesfiles/hdf5/1.8.13
module load /home/lmnp/knut0297/software/modulesfiles/openblas/0.3.20
module load /home/lmnp/knut0297/software/modulesfiles/magick/7.0.8-23
module load /home/lmnp/knut0297/software/modulesfiles/libproj/9.0.0
module load /home/lmnp/knut0297/software/modulesfiles/gsl/2.7
module load /home/lmnp/knut0297/software/modulesfiles/libgeos/3.10.2
module load /home/lmnp/knut0297/software/modulesfiles/gdal/3.4.2
module load /home/lmnp/knut0297/software/modulesfiles/udunits/2.2.28
module load /home/lmnp/knut0297/software/modulesfiles/libsodium/1.0.18
module load /home/lmnp/knut0297/software/modulesfiles/fftw/3.3.10
module load /home/lmnp/knut0297/software/modulesfiles/cmake/3.21.1
module load texlive/20131202
module load java/openjdk-8_202




# Needed for to download a static V8 build of libv8
# https://github.com/jeroen/V8/blob/376ec428b206b5254f2e00f44cb6f41bb433c473/README.md?plain=1#L37
setenv DOWNLOAD_STATIC_LIBV8 1
# Restrict R to only use only one, multi-threaded, core
setenv OMP_NUM_THREADS 1

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path LD_LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib64"
prepend-path LD_LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib64/R/lib"
prepend-path PKG_CONFIG_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib64/pkgconfig"
prepend-path MANPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/share/man"



# Below, will set the user R lib to a version-specific dir, to allow
# other R packages to be compiled against the dynamic external BLAS -- instead
# of being intermixed with the non-external-BLAS modules.
# This external-BLAS-specific library can be confirmed by running 
# Sys.getenv("R_LIBS_USER") within R.
# Using getenv examples: https://modules.readthedocs.io/en/latest/cookbook/test-modulefiles.html
setenv R_LIBS_USER "[getenv HOME]/R/knut0297_software_module/x86_64-pc-linux-gnu-library/$VERSION"


HEREDOC




# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<HEREDOC
#%Module
set ModulesVersion "$VERSION"

HEREDOC








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









#######################################################################
# Block permissions on base R package library dir
#######################################################################

# I do not want anyone (including myself) from writing to the basic R packages dir.
# Remove dir write permissions.
# This will cause R to prompt you to install a R library dir in your home dir.

chmod a-w $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib64/R/library









