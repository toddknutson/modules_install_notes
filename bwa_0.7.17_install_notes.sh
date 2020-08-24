#!/bin/bash

# 2020-08-24

# https://github.com/lh3/bwa



MODULE_NAME=bwa
VERSION=0.7.17
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



module purge
module load gcc/7.2.0
module load zlib/1.2.11


wget https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2
tar xjvf bwa-0.7.17.tar.bz2

cd bwa-0.7.17

make






# Move new executables to a bin dir
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/bin
cd $MODULES_DIR/$MODULE_NAME/$VERSION/bin
mv $MODULES_DIR/$MODULE_NAME/$VERSION/bwa-0.7.17/bwa .
mv $MODULES_DIR/$MODULE_NAME/$VERSION/bwa-0.7.17/*.pl .

# Create a "default" location for storing man files
# Then symlink man file to that location
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/share/man/man1
cd $MODULES_DIR/$MODULE_NAME/$VERSION/share/man/man1
ln -s $MODULES_DIR/$MODULE_NAME/$VERSION/bwa-0.7.17/bwa.1 .



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################


# Create a help message for the module
# e.g. 
# module help <module_name>

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds $MODULE_NAME $VERSION executable to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path    PATH $MODULES_DIR/$MODULE_NAME/$VERSION/bin



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



