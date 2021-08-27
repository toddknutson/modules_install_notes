#!/bin/bash

# 2021-08-24


# https://github.com/s175573/GIANA



MODULE_NAME=giana
VERSION=1.2.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------

mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# Get source code
# latest commit: Aug 21, 2021
# https://github.com/s175573/GIANA/commit/736ccbe5282242961a39e07024f3e66f90aff40b

git clone --recursive https://github.com/s175573/GIANA.git
# Save source code
tar czf GIANA.tar.gz GIANA/

cd $MODULES_DIR/$MODULE_NAME/$VERSION/GIANA
git checkout 736ccbe





# ---------------------------------------------------------------------
# Fix things
# ---------------------------------------------------------------------

# Add execution permissions to scripts
chmod u+rx *.py
chmod u+rx *.R

# Change default python interperter 
# Fix shebang (add so these files can be run as standalone scripts from any dir)
# (but first, remove "usr/bin/python3" specific python from GIANA4.py and GIANAsv.py)
sed -i '1d' GIANA4.py
sed -i '1d' GIANAsv.py
# Add to first line of file before all other lines
sed -i '1i#!/usr/bin/env python3' *.py



# Symlink
ln -s GIANA4.py GIANA.py


# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

# Todd's modules
module load /home/lmnp/knut0297/software/modulesfiles/faiss/1.7.1
module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10

setenv GIANA "$MODULES_DIR/$MODULE_NAME/$VERSION/GIANA"

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/GIANA"

if [ module-info mode load ] {
    puts stderr "* To use the GIANA, activate the python virtual environment: '. /home/lmnp/knut0297/software/python_venvs/giana/bin/activate', and then try 'GIANA4.py -h' on the command line. "
    puts stderr "* An environment variable: GIANA, has been set to: $MODULES_DIR/$MODULE_NAME/$VERSION"
    puts stderr "* To explore the reference data, test data, or R scripts supplied by the program, explore the paths: \\\$GIANA \\\$GIANA/data or \\\$GIANA/Imgt_Human_TRBV.fasta"
}


EOF






# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<EOM
#%Module
set ModulesVersion "$VERSION"

EOM






# ---------------------------------------------------------------------
# Update permissions
# ---------------------------------------------------------------------


# Make all files readable; directories readable and executable
chmod a+rxs $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
chmod a+rxs $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that were already executable for the user, readable and executable for all
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx






