#!/bin/bash

# 2022-02-10


#######################################################################
# 
#######################################################################



MODULE_NAME=cnvkit
VERSION=0.9.9_python3.7.10
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



PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --ignore-installed cnvkit==0.9.9

# 
# Collecting cnvkit==0.9.9
#   Downloading CNVkit-0.9.9.tar.gz (170 kB)
#      |████████████████████████████████| 170 kB 15.5 MB/s
# Collecting biopython>=1.62
#   Using cached biopython-1.79-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.whl (2.3 MB)
# Collecting matplotlib>=1.3.1
#   Downloading matplotlib-3.5.1-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.whl (11.2 MB)
#      |████████████████████████████████| 11.2 MB 35.4 MB/s
# Collecting numpy>=1.9
#   Using cached numpy-1.21.5-cp37-cp37m-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (15.7 MB)
# Collecting pandas>=0.23.3
#   Using cached pandas-1.3.5-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (11.3 MB)
# Collecting pomegranate>=0.9.0
#   Downloading pomegranate-0.14.7.tar.gz (4.3 MB)
#      |████████████████████████████████| 4.3 MB 36.5 MB/s
#   Installing build dependencies ... done
#   Getting requirements to build wheel ... done
#     Preparing wheel metadata ... done
# Collecting pyfaidx>=0.4.7
#   Downloading pyfaidx-0.6.4.tar.gz (100 kB)
#      |████████████████████████████████| 100 kB 3.3 MB/s
# Collecting pysam>=0.10.0
#   Using cached pysam-0.18.0-cp37-cp37m-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (14.9 MB)
# Collecting reportlab>=3.0
#   Downloading reportlab-3.6.6-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (2.8 MB)
#      |████████████████████████████████| 2.8 MB 32.9 MB/s
# Collecting scikit-learn
#   Downloading scikit_learn-1.0.2-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (24.8 MB)
#      |████████████████████████████████| 24.8 MB 35.9 MB/s
# Collecting scipy>=0.15.0
#   Using cached scipy-1.7.3-cp37-cp37m-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (38.1 MB)
# Collecting networkx>=2.4
#   Using cached networkx-2.6.3-py3-none-any.whl (1.9 MB)
# Collecting joblib<1.0
#   Using cached joblib-0.17.0-py3-none-any.whl (301 kB)
# Collecting packaging>=20.0
#   Using cached packaging-21.3-py3-none-any.whl (40 kB)
# Collecting python-dateutil>=2.7
#   Using cached python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
# Collecting cycler>=0.10
#   Downloading cycler-0.11.0-py3-none-any.whl (6.4 kB)
# Collecting pillow>=6.2.0
#   Downloading Pillow-9.0.1-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (4.3 MB)
#      |████████████████████████████████| 4.3 MB 36.3 MB/s
# Collecting fonttools>=4.22.0
#   Downloading fonttools-4.29.1-py3-none-any.whl (895 kB)
#      |████████████████████████████████| 895 kB 30.3 MB/s
# Collecting kiwisolver>=1.0.1
#   Using cached kiwisolver-1.3.2-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.whl (1.1 MB)
# Collecting pyparsing>=2.2.1
#   Using cached pyparsing-3.0.7-py3-none-any.whl (98 kB)
# Collecting pytz>=2017.3
#   Using cached pytz-2021.3-py2.py3-none-any.whl (503 kB)
# Collecting pyyaml
#   Downloading PyYAML-6.0-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl (596 kB)
#      |████████████████████████████████| 596 kB 34.0 MB/s
# Collecting six
#   Using cached six-1.16.0-py2.py3-none-any.whl (11 kB)
# Collecting setuptools>=0.7
#   Using cached setuptools-60.8.2-py3-none-any.whl (1.1 MB)
# Collecting threadpoolctl>=2.0.0
#   Downloading threadpoolctl-3.1.0-py3-none-any.whl (14 kB)
# Using legacy setup.py install for cnvkit, since package 'wheel' is not installed.
# Using legacy setup.py install for pyfaidx, since package 'wheel' is not installed.
# Building wheels for collected packages: pomegranate
#   Building wheel for pomegranate (PEP 517) ... done
#   Created wheel for pomegranate: filename=pomegranate-0.14.7-cp37-cp37m-linux_x86_64.whl size=16947133 sha256=63f25d5e121a0394605da2cbe6848a8c399d5c73aab9d1b0e50cd6787e23e348
#   Stored in directory: /panfs/roc/groups/0/lmnp/knut0297/.cache/pip/wheels/02/0a/89/e53c61d6cd9edc5d7f1b31070038ba0653f8f48b096cd46893
# Successfully built pomegranate
# Installing collected packages: numpy, biopython, pyparsing, packaging, six, python-dateutil, cycler, pillow, fonttools, kiwisolver, matplotlib, pytz, pandas, scipy, networkx, pyyaml, joblib, pomegranate, setuptools, pyfaidx, pysam, reportlab, threadpoolctl, scikit-learn, cnvkit
#   WARNING: The scripts f2py, f2py3 and f2py3.7 are installed in '/home/lmnp/knut0297/software/modules/cnvkit/0.9.9_python3.7.10/build/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
#   WARNING: The scripts fonttools, pyftmerge, pyftsubset and ttx are installed in '/home/lmnp/knut0297/software/modules/cnvkit/0.9.9_python3.7.10/build/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
#     Running setup.py install for pyfaidx ... done
#     Running setup.py install for cnvkit ... done
# Successfully installed biopython-1.79 cnvkit-0.9.9 cycler-0.11.0 fonttools-4.29.1 joblib-0.17.0 kiwisolver-1.3.2 matplotlib-3.5.1 networkx-2.6.3 numpy-1.21.5 packaging-21.3 pandas-1.3.5 pillow-9.0.1 pomegranate-0.14.7 pyfaidx-0.6.4 pyparsing-3.0.7 pysam-0.18.0 python-dateutil-2.8.2 pytz-2021.3 pyyaml-6.0 reportlab-3.6.6 scikit-learn-1.0.2 scipy-1.7.3 setuptools-60.8.2 six-1.16.0 threadpoolctl-3.1.0
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







