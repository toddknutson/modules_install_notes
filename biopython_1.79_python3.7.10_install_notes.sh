#!/bin/bash

# 2021-08-24


#######################################################################
# 
#######################################################################



MODULE_NAME=biopython
VERSION=1.79_python3.7.10
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



module purge
module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10

# Set up a folder for all python stuff called "build"
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build


PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --ignore-installed biopython==1.79




# 
# Collecting biopython==1.79
#   Downloading biopython-1.79-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.whl (2.3 MB)
#      |████████████████████████████████| 2.3 MB 26.9 MB/s
# Collecting numpy
#   Downloading numpy-1.21.2-cp37-cp37m-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (15.7 MB)
#      |████████████████████████████████| 15.7 MB 38.1 MB/s
# Installing collected packages: numpy, biopython
#   WARNING: The scripts f2py, f2py3 and f2py3.7 are installed in '/home/lmnp/knut0297/software/modules/biopython/1.79_python3.7.10/build/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
# Successfully installed biopython-1.79 numpy-1.21.2
# WARNING: You are using pip version 20.1.1; however, version 21.2.4 is available.
# You should consider upgrading via the '/home/lmnp/knut0297/software/modules/python3/3.7.10/build/bin/python3.7 -m pip install --upgrade pip' command.
# 





# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<ENDOFMESSAGE
#%Module######################################################################

module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/python3.7/site-packages"


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

# Make all files readable; directories readable and executable
chmod a+rxs $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
chmod a+rxs $MODULESFILES_DIR/$MODULE_NAME
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that were already executable for the user, readable and executable for all
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx



