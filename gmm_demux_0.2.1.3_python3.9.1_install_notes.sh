#!/bin/bash

# 2019-11-13


#######################################################################
# 
#######################################################################



MODULE_NAME=gmm_demux
VERSION=0.2.1.3_python3.9.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



module purge
module load /home/lmnp/knut0297/software/modulesfiles/python3/3.9.1


# Set up a folder for all python stuff called "build"
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build

# Determine which pip is being called
pip -V

# To find versions, try installing without a version number (e.g. GMM_Demux==)
# The latest version can also be found on github, in the setup.py file.

PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --ignore-installed GMM_Demux==0.2.1.3





# 
# Collecting GMM_Demux==0.2.1.3
#   Using cached GMM_Demux-0.2.1.3-py3-none-any.whl (17 kB)
# Processing /panfs/roc/groups/0/lmnp/knut0297/.cache/pip/wheels/76/03/bb/589d421d27431bcd2c6da284d5f2286c8e3b2ea3cf1594c074/sklearn-0.0-py2.py3-none-any.whl
# Collecting argparse
#   Using cached argparse-1.4.0-py2.py3-none-any.whl (23 kB)
# Collecting tabulate
#   Using cached tabulate-0.8.7-py3-none-any.whl (24 kB)
# Collecting pandas>=0.25
#   Downloading pandas-1.2.0-cp39-cp39-manylinux1_x86_64.whl (9.7 MB)
#      |████████████████████████████████| 9.7 MB 12.6 MB/s
# Collecting scipy
#   Downloading scipy-1.6.0-cp39-cp39-manylinux1_x86_64.whl (27.3 MB)
#      |████████████████████████████████| 27.3 MB 44.3 MB/s
# Collecting statistics
#   Using cached statistics-1.0.3.5.tar.gz (8.3 kB)
# Collecting numpy
#   Downloading numpy-1.19.5-cp39-cp39-manylinux2010_x86_64.whl (14.9 MB)
#      |████████████████████████████████| 14.9 MB 46.5 MB/s
# Collecting BitVector
#   Using cached BitVector-3.4.9.tar.gz (128 kB)
# Collecting scikit-learn
#   Downloading scikit_learn-0.24.0-cp39-cp39-manylinux2010_x86_64.whl (23.8 MB)
#      |████████████████████████████████| 23.8 MB 46.4 MB/s
# Collecting pytz>=2017.3
#   Using cached pytz-2020.5-py2.py3-none-any.whl (510 kB)
# Collecting python-dateutil>=2.7.3
#   Using cached python_dateutil-2.8.1-py2.py3-none-any.whl (227 kB)
# Collecting docutils>=0.3
#   Using cached docutils-0.16-py2.py3-none-any.whl (548 kB)
# Collecting threadpoolctl>=2.0.0
#   Using cached threadpoolctl-2.1.0-py3-none-any.whl (12 kB)
# Collecting joblib>=0.11
#   Using cached joblib-1.0.0-py3-none-any.whl (302 kB)
# Collecting six>=1.5
#   Using cached six-1.15.0-py2.py3-none-any.whl (10 kB)
# Using legacy 'setup.py install' for statistics, since package 'wheel' is not installed.
# Using legacy 'setup.py install' for BitVector, since package 'wheel' is not installed.
# Installing collected packages: numpy, threadpoolctl, scipy, joblib, scikit-learn, sklearn, argparse, tabulate, pytz, six, python-dateutil, pandas, docutils, statistics, BitVector, GMM-Demux
#   WARNING: The scripts f2py, f2py3 and f2py3.9 are installed in '/home/lmnp/knut0297/software/modules/gmm_demux/0.2.1.3_python3.9.1/build/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
#   WARNING: The script tabulate is installed in '/home/lmnp/knut0297/software/modules/gmm_demux/0.2.1.3_python3.9.1/build/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
#     Running setup.py install for statistics ... done
#     Running setup.py install for BitVector ... done
#   WARNING: The script GMM-demux is installed in '/home/lmnp/knut0297/software/modules/gmm_demux/0.2.1.3_python3.9.1/build/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
# Successfully installed BitVector-3.4.9 GMM-Demux-0.2.1.3 argparse-1.4.0 docutils-0.16 joblib-1.0.0 numpy-1.19.5 pandas-1.2.0 python-dateutil-2.8.1 pytz-2020.5 scikit-learn-0.24.0 scipy-1.6.0 six-1.15.0 sklearn-0.0 statistics-1.0.3.5 tabulate-0.8.7 threadpoolctl-2.1.0
# WARNING: You are using pip version 20.2.3; however, version 20.3.3 is available.
# You should consider upgrading via the '/home/lmnp/knut0297/software/modules/python3/3.9.1/build/bin/python3.9 -m pip install --upgrade pip' command.




# ---------------------------------------------------------------------
# Execution note
# ---------------------------------------------------------------------

# After loading the gmm_demux module, simply use the executable, "GMM-demux --help", on the bash command line




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOM
#%Module######################################################################

module load /home/lmnp/knut0297/software/modulesfiles/python3/3.9.1
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/python3.9/site-packages"


EOM



# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<EOM
#%Module
set ModulesVersion "$VERSION"

EOM






# ---------------------------------------------------------------------
# Update permissions (if you want to share the module)
# ---------------------------------------------------------------------


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs
find $MODULESFILES_DIR/$MODULE_NAME/$VERSION -type d -print0 | xargs -0 chmod a+rxs

# Make all files readable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME/$VERSION -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME/$VERSION -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory







