#!/bin/bash

# 2021-03-05

#######################################################################
# 
#######################################################################

# https://github.com/PacificBiosciences/pbampliconclustering


# The latest version can be found on github, in the setup.py file.
MODULE_NAME=pbampliconclustering
VERSION=0.0.2_python3.7.10
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# Clone everything
git clone --recursive git@github.com:PacificBiosciences/pbampliconclustering.git
cd $MODULES_DIR/$MODULE_NAME/$VERSION/pbampliconclustering
# Checkout the newest commit (Feb 2, 2021)
git checkout cc0efd2
git reset --hard
git checkout master


# Change numpy version
sed -i 's/numpy/numpy>=1.16.5/' setup.py

module purge
module load python3/3.7.10

# Set up a folder for all python stuff called "build"
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build


which python
# /home/lmnp/knut0297/software/modules/python3/3.7.10/build/bin/python

# NOTE: In this version of python3, you can use pip to install a local program (i.e. pip
# uses the current dir [.] setup.py for how to install the package)
# https://stackoverflow.com/a/1472014/2367748
PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --ignore-installed .

# Running setup.py directly did not work well -- DO NOT RUN THIS
# PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build python setup.py install --user


# 
# ERROR: When trying to compile with python 3.9, I got this error. Thus, use python 3.7.10 instead
# python/mappy.c:8053:31: error: ‘PyTypeObject {aka struct _typeobject}’ has no member named ‘tp_print’; did you mean ‘tp_dict’?
#    __pyx_type_5mappy_Alignment.tp_print = 0;
#                                ^~~~~~~~
#                                tp_dict






# 
# 
# Processing /panfs/roc/groups/0/lmnp/knut0297/software/modules/pbampliconclustering/0.0.2_python3.7.10/pbampliconclustering
# Collecting scikit-learn>=0.22
#   Downloading scikit_learn-0.24.1-cp37-cp37m-manylinux2010_x86_64.whl (22.3 MB)
#      |████████████████████████████████| 22.3 MB 18.4 MB/s
# Collecting numpy>=1.16.5
#   Downloading numpy-1.20.1-cp37-cp37m-manylinux2010_x86_64.whl (15.3 MB)
#      |████████████████████████████████| 15.3 MB 33.7 MB/s
# Collecting pandas>=1
#   Downloading pandas-1.2.3-cp37-cp37m-manylinux1_x86_64.whl (9.9 MB)
#      |████████████████████████████████| 9.9 MB 34.2 MB/s
# Collecting pysam>=0.15
#   Downloading pysam-0.16.0.1-cp37-cp37m-manylinux1_x86_64.whl (9.9 MB)
#      |████████████████████████████████| 9.9 MB 38.6 MB/s
# Collecting mappy>=2.17
#   Downloading mappy-2.17.tar.gz (199 kB)
#      |████████████████████████████████| 199 kB 47.1 MB/s
# Collecting matplotlib>=3
#   Downloading matplotlib-3.3.4-cp37-cp37m-manylinux1_x86_64.whl (11.5 MB)
#      |████████████████████████████████| 11.5 MB 36.3 MB/s
# Collecting seaborn>=0.10
#   Downloading seaborn-0.11.1-py3-none-any.whl (285 kB)
#      |████████████████████████████████| 285 kB 50.6 MB/s
# Collecting scipy
#   Downloading scipy-1.6.1-cp37-cp37m-manylinux1_x86_64.whl (27.4 MB)
#      |████████████████████████████████| 27.4 MB 38.6 MB/s
# Collecting joblib>=0.11
#   Downloading joblib-1.0.1-py3-none-any.whl (303 kB)
#      |████████████████████████████████| 303 kB 45.7 MB/s
# Collecting threadpoolctl>=2.0.0
#   Using cached threadpoolctl-2.1.0-py3-none-any.whl (12 kB)
# Collecting pytz>=2017.3
#   Downloading pytz-2021.1-py2.py3-none-any.whl (510 kB)
#      |████████████████████████████████| 510 kB 39.1 MB/s
# Collecting python-dateutil>=2.7.3
#   Using cached python_dateutil-2.8.1-py2.py3-none-any.whl (227 kB)
# Collecting pillow>=6.2.0
#   Downloading Pillow-8.1.2-cp37-cp37m-manylinux1_x86_64.whl (2.2 MB)
#      |████████████████████████████████| 2.2 MB 35.9 MB/s
# Collecting kiwisolver>=1.0.1
#   Downloading kiwisolver-1.3.1-cp37-cp37m-manylinux1_x86_64.whl (1.1 MB)
#      |████████████████████████████████| 1.1 MB 35.1 MB/s
# Collecting pyparsing!=2.0.4,!=2.1.2,!=2.1.6,>=2.0.3
#   Using cached pyparsing-2.4.7-py2.py3-none-any.whl (67 kB)
# Collecting cycler>=0.10
#   Using cached cycler-0.10.0-py2.py3-none-any.whl (6.5 kB)
# Collecting six>=1.5
#   Using cached six-1.15.0-py2.py3-none-any.whl (10 kB)
# Using legacy setup.py install for pbampliconphasing, since package 'wheel' is not installed.
# Using legacy setup.py install for mappy, since package 'wheel' is not installed.
# Installing collected packages: numpy, scipy, joblib, threadpoolctl, scikit-learn, pytz, six, python-dateutil, pandas, pysam, mappy, pillow, kiwisolver, pyparsing, cycler, matplotlib, seaborn, pbampliconphasing
#   WARNING: The scripts f2py, f2py3 and f2py3.7 are installed in '/home/lmnp/knut0297/software/modules/pbampliconclustering/0.0.2_python3.7.10/build/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
#     Running setup.py install for mappy ... done
#     Running setup.py install for pbampliconphasing ... done
# Successfully installed cycler-0.10.0 joblib-1.0.1 kiwisolver-1.3.1 mappy-2.17 matplotlib-3.3.4 numpy-1.20.1 pandas-1.2.3 pbampliconphasing-0.0.2 pillow-8.1.2 pyparsing-2.4.7 pysam-0.16.0.1 python-dateutil-2.8.1 pytz-2021.1 scikit-learn-0.24.1 scipy-1.6.1 seaborn-0.11.1 six-1.15.0 threadpoolctl-2.1.0
# WARNING: You are using pip version 20.1.1; however, version 21.0.1 is available.
# You should consider upgrading via the '/home/lmnp/knut0297/software/modules/python3/3.7.10/build/bin/python3.7 -m pip install --upgrade pip' command.
# 





# ---------------------------------------------------------------------
# Change scripts
# ---------------------------------------------------------------------

cd $MODULES_DIR/$MODULE_NAME/$VERSION/pbampliconclustering
chmod u+rx ClusterAmplicons.py
chmod u+rx LongAmpliconPhasing.py
chmod u+rx motifCounter.py
chmod u+rx tagClusters.py

# Fix shebang (first, remove anaconda specific python from ClusterAmplicons.py)
sed -i '1d' ClusterAmplicons.py

# Fix shebang (add so these files can be run as standalone scripts from any dir)
sed -i '1i#!/usr/bin/env python3' ClusterAmplicons.py
sed -i '1i#!/usr/bin/env python3' LongAmpliconPhasing.py
sed -i '1i#!/usr/bin/env python3' motifCounter.py
sed -i '1i#!/usr/bin/env python3' tagClusters.py




# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOM
#%Module######################################################################

module load python3/3.7.10
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/pbampliconclustering"
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/python3.7/site-packages"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/pbampliconclustering"

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



#######################################################################
# USAGE EXAMPLE
#######################################################################

# 
# module load pbampliconclustering/0.0.2_python3.7.10
# cd my_fav_project_dir
# ClusterAmplicons.py cluster -j 1 --inFastq "sample.A01--A01.ccs.fastq" --plotReads 5 --prefix all
#


