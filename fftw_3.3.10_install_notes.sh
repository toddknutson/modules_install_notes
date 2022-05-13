#!/bin/bash

# 2022-05-05

# NOTES:

# Some package managers call this program by different names depending on whether is was
# compiled with single precision (float) or double precision (long). Then the names might
# be fftw3f (for version 3, float single precision). See `doc/modern-fortran.texi` for 
# details regarding library names.

# For example: https://github.com/openwrt/packages/blob/17ab4ed4e4e727bca53a4a68e816baac463fb692/libs/fftw3/Makefile#L34-L45

# To genearte the fftw3f.pc file needed by some R packages you may need to
# use the configure option "--enable-float". Otherwise, the resulting files are named
# "fftw3.pc" and R cannot use them. This installation built the "fftw3.pc" file.



# If not a slurm job, set THREADS to 1
export THREADS=$([ ! -z ${SLURM_CPUS_PER_TASK+x} ] && echo ${SLURM_CPUS_PER_TASK} || echo 1)


MODULE_NAME=fftw
VERSION=3.3.10
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------



mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/bin
cd $MODULES_DIR/$MODULE_NAME/$VERSION



wget ftp://ftp.fftw.org/pub/fftw/${MODULE_NAME}-${VERSION}.tar.gz
tar xvf ${MODULE_NAME}-${VERSION}.tar.gz


cd $MODULES_DIR/$MODULE_NAME/$VERSION/${MODULE_NAME}-${VERSION}


module purge
module load gcc/7.2.0


./configure \
--prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build \
--enable-shared \
--enable-threads



make -j $THREADS
make -j $THREADS install prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME





cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path LD_LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib"
prepend-path LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib"
prepend-path C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path CPLUS_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path PKG_CONFIG_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/pkgconfig"

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






