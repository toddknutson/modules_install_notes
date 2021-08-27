#!/bin/bash

# 2021-08-24


#######################################################################
# 
#######################################################################



MODULE_NAME=scikit-learn
VERSION=0.24.2_python3.7.10
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


PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --ignore-installed scikit-learn==0.24.2

python -c "import sklearn; sklearn.show_versions()"



# 
# 
# Collecting scikit-learn==0.24.2
#   Downloading scikit_learn-0.24.2-cp37-cp37m-manylinux2010_x86_64.whl (22.3 MB)
#      |████████████████████████████████| 22.3 MB 15.7 MB/s
# Collecting joblib>=0.11
#   Using cached joblib-1.0.1-py3-none-any.whl (303 kB)
# Collecting threadpoolctl>=2.0.0
#   Downloading threadpoolctl-2.2.0-py3-none-any.whl (12 kB)
# Collecting numpy>=1.13.3
#   Using cached numpy-1.21.2-cp37-cp37m-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (15.7 MB)
# Collecting scipy>=0.19.1
#   Downloading scipy-1.7.1-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.whl (28.5 MB)
#      |████████████████████████████████| 28.5 MB 67.8 MB/s
# Installing collected packages: joblib, threadpoolctl, numpy, scipy, scikit-learn
#   WARNING: The scripts f2py, f2py3 and f2py3.7 are installed in '/home/lmnp/knut0297/software/modules/scikit-learn/0.24.2_python3.7.10/build/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
# Successfully installed joblib-1.0.1 numpy-1.21.2 scikit-learn-0.24.2 scipy-1.7.1 threadpoolctl-2.2.0
# WARNING: You are using pip version 20.1.1; however, version 21.2.4 is available.
# You should consider upgrading via the '/home/lmnp/knut0297/software/modules/python3/3.7.10/build/bin/python3.7 -m pip install --upgrade pip' command.




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



