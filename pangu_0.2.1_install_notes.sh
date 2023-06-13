#!/bin/bash

# 2022-12-20




MODULE_NAME=pangu
VERSION=0.2.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

module load mamba/0.11.3
mamba create -v --prefix "mamba_pangu" python=3.9 pip setuptools

source activate $MODULES_DIR/$MODULE_NAME/$VERSION/mamba_pangu

wget https://github.com/PacificBiosciences/pangu/archive/refs/tags/v$VERSION.tar.gz
tar xvzf v$VERSION.tar.gz
cd $MODULES_DIR/$MODULE_NAME/$VERSION/$MODULE_NAME-$VERSION

pip install .


deactivate




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME



cat > $VERSION <<EOF
#%Module
module load mamba

if [ module-info mode load ] {
    puts stderr "* To use the pangu package, activate the python mamba environment: 'source acitvate $MODULES_DIR/$MODULE_NAME/$VERSION', and then try 'python -c \\"import pangu\\"'"
}

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




