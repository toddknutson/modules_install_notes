#!/bin/bash

# 2019-04-22


#######################################################################
# SUCCESSFUL INSTALL and TESTED - works on 2019-04-22
#######################################################################



# lumpy structural variant calling
# https://github.com/arq5x/lumpy-sv#installation





MODULE_NAME=lumpy
VERSION=0.3.0_plus4commits
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION




# Get source code
# 2019-04-22
# Four commits past 0.3.0
# https://github.com/arq5x/lumpy-sv/commit/800c67ca5b454d01e7019bdcdda63e11ff7b3968
git clone --recursive https://github.com/arq5x/lumpy-sv.git
git checkout 800c67ca5b454d01e7019bdcdda63e11ff7b3968

cd lumpy-sv



# install dependencies
module purge
module load samtools/1.9
module load samblaster/0.1.24
module load python2/2.7.15_anaconda
which gawk # installed at system level /usr/bin
module load sambamba/0.6.9
module load gcc/7.2.0


# Find custom zlib library dir
module load zlib/1.2.11_gcc7.2.0
module display zlib/1.2.11_gcc7.2.0
export ZLIB_PATH="/panfs/roc/msisoft/zlib/1.2.11_gcc7.2.0/lib/"



# Compile lumpy
make






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
        puts stderr "\tThis module adds lumpy executable to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/lumpy-sv/bin"
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/lumpy-sv/scripts"
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/lumpy-sv/scripts/bamkit"

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




