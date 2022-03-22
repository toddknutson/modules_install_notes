#!/bin/bash

# 2022-02-10


#######################################################################
# 
#######################################################################



MODULE_NAME=hmmlearn
VERSION=0.2.7_python3.7.10
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



module purge
module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10
module load gcc/8.1.0


# Set up a folder for all python stuff called "build"
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build



PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --ignore-installed hmmlearn==0.2.7


# 
# Collecting hmmlearn==0.2.7
#   Downloading hmmlearn-0.2.7-cp37-cp37m-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (129 kB)
#      |████████████████████████████████| 129 kB 21.4 MB/s
# Collecting scipy>=0.19
#   Using cached scipy-1.7.3-cp37-cp37m-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (38.1 MB)
# Collecting numpy>=1.10
#   Using cached numpy-1.21.5-cp37-cp37m-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (15.7 MB)
# Collecting scikit-learn>=0.16
#   Using cached scikit_learn-1.0.2-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (24.8 MB)
# Collecting threadpoolctl>=2.0.0
#   Using cached threadpoolctl-3.1.0-py3-none-any.whl (14 kB)
# Collecting joblib>=0.11
#   Downloading joblib-1.1.0-py2.py3-none-any.whl (306 kB)
#      |████████████████████████████████| 306 kB 39.1 MB/s
# Installing collected packages: numpy, scipy, threadpoolctl, joblib, scikit-learn, hmmlearn
#   WARNING: The scripts f2py, f2py3 and f2py3.7 are installed in '/home/lmnp/knut0297/software/modules/hmmlearn/0.2.7_python3.7.10/build/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
# Successfully installed hmmlearn-0.2.7 joblib-1.1.0 numpy-1.21.5 scikit-learn-1.0.2 scipy-1.7.3 threadpoolctl-3.1.0
# WARNING: You are using pip version 20.1.1; however, version 22.0.3 is available.
# You should consider upgrading via the '/home/lmnp/knut0297/software/modules/python3/3.7.10/build/bin/python3.7 -m pip install --upgrade pip' command.


# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<HEREDOC
#%Module######################################################################

module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/python3.7/site-packages"


HEREDOC





# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<HEREDOC
#%Module
set ModulesVersion "$VERSION"

HEREDOC





# ---------------------------------------------------------------------
# Update permissions (if you want to share the module)
# ---------------------------------------------------------------------


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME -maxdepth 0 -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULESFILES_DIR/$MODULE_NAME -maxdepth 0 -type d -print0 | xargs -0 chmod a+rxs,go-w
find $MODULESFILES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs,go-w

# Make all files readable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r,go-w
find $MODULESFILES_DIR/$MODULE1_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r,go-w

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx,go-w
# Note: there are no executable files in the modulesfiles directory












