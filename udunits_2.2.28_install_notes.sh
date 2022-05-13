#!/bin/bash

# 2022-05-02
# https://artifacts.unidata.ucar.edu/service/rest/repository/browse/downloads-udunits/current/
# https://www.unidata.ucar.edu/downloads/udunits/



# If not a slurm job, set THREADS to 1
export THREADS=$([ ! -z ${SLURM_CPUS_PER_TASK+x} ] && echo ${SLURM_CPUS_PER_TASK} || echo 1)


MODULE_NAME=udunits
VERSION=2.2.28
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------



mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://artifacts.unidata.ucar.edu/repository/downloads-udunits/${VERSION}/udunits-${VERSION}.tar.gz

tar xvzf ${MODULE_NAME}-${VERSION}.tar.gz

cd $MODULES_DIR/$MODULE_NAME/$VERSION/${MODULE_NAME}-${VERSION}

module purge
module load gcc/7.2.0

./configure --prefix="$MODULES_DIR/$MODULE_NAME/$VERSION/build"


make -j $THREADS
make install

# 
# 
# Libraries have been installed in:
#    /home/lmnp/knut0297/software/modules/udunits/2.2.28/build/lib
# 
# If you ever happen to want to link against installed libraries
# in a given directory, LIBDIR, you must either use libtool, and
# specify the full pathname of the library, or use the `-LLIBDIR'
# flag during linking and do at least one of the following:
#    - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
#      during execution
#    - add LIBDIR to the `LD_RUN_PATH' environment variable
#      during linking
#    - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
#    - have your system administrator add LIBDIR to `/etc/ld.so.conf'
# 
# See any operating system documentation about shared libraries for
# more information, such as the ld(1) and ld.so(8) manual pages.



# Needed to easily install "udunits2" and "units" R packages without specifying additional 
# command line args to install.packages()
#setenv UDUNITS2_INCLUDE "/home/lmnp/knut0297/software/modulesfiles/udunits/2.2.28/build/include"
#setenv UDUNITS2_LIBS "/home/lmnp/knut0297/software/modulesfiles/udunits/2.2.28/build/lib"

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
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path LD_RUN_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
setenv UDUNITS2_INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
setenv UDUNITS2_LIBS $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib

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






