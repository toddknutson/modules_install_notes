#!/bin/bash

# 2020-10-05


#######################################################################
# 
#######################################################################






MODULE_NAME=blat
VERSION=3.6
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION




# blat (same version as current) -- 35x1 
# NOTE: there is a non-profit license waiver for blat included as a precaution
# requires: mysql-devel libpng-devel
curl -L -O http://hgwdev.cse.ucsc.edu/~kent/src/blatSrc36.zip
unzip -d . blatSrc36.zip
cd $MODULES_DIR/$MODULE_NAME/$VERSION/blatSrc


module purge
#module load libpng/1.6.34
module load gcc/7.2.0

mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/bin

make COPT="-g -O2" PREFIX="$MODULES_DIR/$MODULE_NAME/$VERSION" BINDIR="$MODULES_DIR/$MODULE_NAME/$VERSION/bin" MACHTYPE="x86_64"






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
prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/bin

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



