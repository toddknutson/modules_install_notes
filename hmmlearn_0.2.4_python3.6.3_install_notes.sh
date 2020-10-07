#!/bin/bash

# 2020-10-05


#######################################################################
# 
#######################################################################



MODULE_NAME=hmmlearn
VERSION=0.2.4_python3.6.3
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



module purge
module load python3/3.6.3_anaconda5.0.1
module load gcc/8.1.0


# Set up a folder for all python stuff called "build"
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build



PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --ignore-installed hmmlearn==0.2.4



# STDOUT:
# Collecting hmmlearn==0.2.4
#   Downloading https://files.pythonhosted.org/packages/b3/49/9e9a89cee24b26ef6afec5abbd5eb9cf14632855f32b999389873ecb1b4e/hmmlearn-0.2.4-cp36-cp36m-manylinux1_x86_64.whl (361kB)
#     100% |████████████████████████████████| 368kB 1.4MB/s
# Collecting scipy>=0.19 (from hmmlearn==0.2.4)
#   Using cached https://files.pythonhosted.org/packages/2b/a8/f4c66eb529bb252d50e83dbf2909c6502e2f857550f22571ed8556f62d95/scipy-1.5.2-cp36-cp36m-manylinux1_x86_64.whl
# Collecting numpy>=1.10 (from hmmlearn==0.2.4)
#   Using cached https://files.pythonhosted.org/packages/b8/e5/a64ef44a85397ba3c377f6be9c02f3cb3e18023f8c89850dd319e7945521/numpy-1.19.2-cp36-cp36m-manylinux1_x86_64.whl
# Collecting scikit-learn>=0.16 (from hmmlearn==0.2.4)
#   Using cached https://files.pythonhosted.org/packages/5c/a1/273def87037a7fb010512bbc5901c31cfddfca8080bc63b42b26e3cc55b3/scikit_learn-0.23.2-cp36-cp36m-manylinux1_x86_64.whl
# Collecting joblib>=0.11 (from scikit-learn>=0.16->hmmlearn==0.2.4)
#   Downloading https://files.pythonhosted.org/packages/fc/c9/f58220ac44a1592f79a343caba12f6837f9e0c04c196176a3d66338e1ea8/joblib-0.17.0-py3-none-any.whl (301kB)
#     100% |████████████████████████████████| 307kB 1.6MB/s
# Collecting threadpoolctl>=2.0.0 (from scikit-learn>=0.16->hmmlearn==0.2.4)
#   Using cached https://files.pythonhosted.org/packages/f7/12/ec3f2e203afa394a149911729357aa48affc59c20e2c1c8297a60f33f133/threadpoolctl-2.1.0-py3-none-any.whl
# Installing collected packages: numpy, scipy, joblib, threadpoolctl, scikit-learn, hmmlearn
# Successfully installed hmmlearn-0.2.4 joblib-0.17.0 numpy-1.19.2 scikit-learn-0.23.2 scipy-1.5.2 threadpoolctl-2.1.0
# You are using pip version 9.0.1, however version 20.2.3 is available.
# You should consider upgrading via the 'pip install --upgrade pip' command.







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
        puts stderr "\tThis module adds $MODULE_NAME $VERSION executable to your path."
}


# Update the necessary shell environment variables to make the software work
module load python3/3.6.3_anaconda5.0.1
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/python3.6/site-packages"


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







