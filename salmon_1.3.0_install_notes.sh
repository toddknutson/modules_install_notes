#!/bin/bash

# 2020-09-08


#######################################################################
# 
#######################################################################






MODULE_NAME=salmon
VERSION=1.3.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



# Get the binary for linux
wget https://github.com/COMBINE-lab/salmon/archive/v1.3.0.tar.gz

tar xvzf v1.3.0.tar.gz



rm -r $MODULES_DIR/$MODULE_NAME/$VERSION/salmon-1.3.0/build
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/salmon-1.3.0/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION/salmon-1.3.0/build



module purge
module load boost/1.72.0/gnu-9.2.0
module load cmake/3.12.3
module load gcc/7.2.0
which g++
g++ --version


cmake .. -DCMAKE_INSTALL_PREFIX=$MODULES_DIR/$MODULE_NAME/$VERSION -DCMAKE_CXX_COMPILER=$(which g++) -DCMAKE_C_COMPILER=$(which gcc)

make CXX=$(which g++) CC=$(which gcc)
make install




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
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"
prepend-path LD_LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/lib"

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



