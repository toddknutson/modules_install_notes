#!/bin/bash

# 2021-06-15


#######################################################################
# 
#######################################################################



MODULE_NAME=umi_tools
VERSION=1.1.2_python3.7.10
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



module purge
module load python3/3.7.10



# Clone everything
git clone --recursive git@github.com:CGATOxford/UMI-tools.git
cd $MODULES_DIR/$MODULE_NAME/$VERSION/UMI-tools
# Checkout the latest version (1.1.2)
git checkout 0c7e86b
git reset --hard
git checkout master




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
# Processing /panfs/roc/groups/0/lmnp/knut0297/software/modules/umi_tools/1.1.2_python3.7.10/UMI-tools
# Collecting setuptools>=1.1
#   Using cached setuptools-57.0.0-py3-none-any.whl (821 kB)
# Collecting numpy>=1.7
#   Using cached numpy-1.20.3-cp37-cp37m-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (15.3 MB)
# Collecting pandas>=0.12.0
#   Using cached pandas-1.2.4-cp37-cp37m-manylinux1_x86_64.whl (9.9 MB)
# Collecting future
#   Using cached future-0.18.2.tar.gz (829 kB)
# Collecting regex
#   Using cached regex-2021.4.4-cp37-cp37m-manylinux2014_x86_64.whl (720 kB)
# Collecting scipy
#   Using cached scipy-1.6.3-cp37-cp37m-manylinux1_x86_64.whl (27.4 MB)
# Collecting matplotlib
#   Using cached matplotlib-3.4.2-cp37-cp37m-manylinux1_x86_64.whl (10.3 MB)
# Collecting pybktree
#   Using cached pybktree-1.1.tar.gz (4.5 kB)
# Collecting pysam
#   Using cached pysam-0.16.0.1-cp37-cp37m-manylinux1_x86_64.whl (9.9 MB)
# Collecting python-dateutil>=2.7.3
#   Using cached python_dateutil-2.8.1-py2.py3-none-any.whl (227 kB)
# Collecting pytz>=2017.3
#   Using cached pytz-2021.1-py2.py3-none-any.whl (510 kB)
# Collecting pillow>=6.2.0
#   Using cached Pillow-8.2.0-cp37-cp37m-manylinux1_x86_64.whl (3.0 MB)
# Collecting kiwisolver>=1.0.1
#   Using cached kiwisolver-1.3.1-cp37-cp37m-manylinux1_x86_64.whl (1.1 MB)
# Collecting pyparsing>=2.2.1
#   Using cached pyparsing-2.4.7-py2.py3-none-any.whl (67 kB)
# Collecting cycler>=0.10
#   Using cached cycler-0.10.0-py2.py3-none-any.whl (6.5 kB)
# Collecting six>=1.5
#   Using cached six-1.16.0-py2.py3-none-any.whl (11 kB)
# Using legacy setup.py install for umi-tools, since package 'wheel' is not installed.
# Using legacy setup.py install for future, since package 'wheel' is not installed.
# Using legacy setup.py install for pybktree, since package 'wheel' is not installed.
# Installing collected packages: setuptools, numpy, six, python-dateutil, pytz, pandas, future, regex, scipy, pillow, kiwisolver, pyparsing, cycler, matplotlib, pybktree, pysam, umi-tools
#   WARNING: The scripts f2py, f2py3 and f2py3.7 are installed in '/home/lmnp/knut0297/software/modules/umi_tools/1.1.2_python3.7.10/build/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
#     Running setup.py install for future ... done
#     Running setup.py install for pybktree ... done
#     Running setup.py install for umi-tools ... done
# Successfully installed cycler-0.10.0 future-0.18.2 kiwisolver-1.3.1 matplotlib-3.4.2 numpy-1.20.3 pandas-1.2.4 pillow-8.2.0 pybktree-1.1 pyparsing-2.4.7 pysam-0.16.0.1 python-dateutil-2.8.1 pytz-2021.1 regex-2021.4.4 scipy-1.6.3 setuptools-57.0.0 six-1.16.0 umi-tools-1.1.2
# WARNING: You are using pip version 20.1.1; however, version 21.1.2 is available.
# You should consider upgrading via the '/home/lmnp/knut0297/software/modules/python3/3.7.10/build/bin/python3.7 -m pip install --upgrade pip' command.







# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME



cat > $VERSION <<EOM
#%Module######################################################################

module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10
#prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/UMI-tools"
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/python3.7/site-packages"
#prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/UMI-tools"

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





