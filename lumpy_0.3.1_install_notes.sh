#!/bin/bash

# 2021-08-09


# lumpy structural variant calling
# https://github.com/arq5x/lumpy-sv#installation


MODULE_NAME=lumpy
VERSION=0.3.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION




# Get source code
# 2020-09-14
# https://github.com/arq5x/lumpy-sv/commit/8f93887b12026142f993dbfd72615a6d3372cd34
git clone --recursive https://github.com/arq5x/lumpy-sv.git
git checkout 8f93887b12026142f993dbfd72615a6d3372cd34

cd lumpy-sv



# install dependencies
module purge
module load /home/lmnp/knut0297/software/modulesfiles/samtools/1.9
module load /home/lmnp/knut0297/software/modulesfiles/samblaster/0.1.24

# TRY THIS PYTHON
module load /home/lmnp/knut0297/software/modulesfiles/python2/2.7.15
which gawk # installed at system level /usr/bin
module load /home/lmnp/knut0297/software/modulesfiles/sambamba/0.6.9
module load gcc/7.2.0


# Find custom zlib library dir
module load zlib/1.2.11_gcc7.2.0
module display zlib/1.2.11_gcc7.2.0
export ZLIB_PATH="/panfs/roc/msisoft/zlib/1.2.11_gcc7.2.0/lib/"



# Compile lumpy
make -j 16






# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOM
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/lumpy-sv/bin"
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/lumpy-sv/scripts"
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/lumpy-sv/scripts/bamkit"

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

# Make all files readable; directories readable and executable
chmod a+rxs $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
chmod a+rxs $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that were already executable for the user, readable and executable for all
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx

