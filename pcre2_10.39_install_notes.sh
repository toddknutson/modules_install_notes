#!/bin/bash

# 2022-03-11

# If not a slurm job, set THREADS to 1
export THREADS=$([ ! -z ${SLURM_CPUS_PER_TASK+x} ] && echo ${SLURM_CPUS_PER_TASK} || echo 1)


MODULE_NAME=pcre2
VERSION=10.39
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://github.com/PhilipHazel/pcre2/releases/download/pcre2-10.39/pcre2-10.39.tar.gz
tar xvzf pcre2-10.39.tar.gz

cd $MODULES_DIR/$MODULE_NAME/$VERSION/pcre2-10.39

module purge
module load gcc/7.2.0


./configure \
--prefix="$MODULES_DIR/$MODULE_NAME/$VERSION/build" \
--docdir="$MODULES_DIR/$MODULE_NAME/$VERSION/build/share/doc" \
--enable-unicode \
--enable-jit \
--enable-pcre2-16 \
--enable-pcre2-32 \
--enable-pcre2grep-libz \
--enable-pcre2grep-libbz2 \
--enable-pcre2test-libreadline \
--disable-static



make -j $THREADS
make -j $THREADS check
make install




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME





cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path MANPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/share/man"
prepend-path INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path CPATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path C_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path CPLUS_INCLUDE_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path FPATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path LD_RUN_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path PKG_CONFIG_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/pkgconfig


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






