#!/bin/bash

# 2020-03-12


#######################################################################
# 
#######################################################################



MODULE_NAME=whatshap
VERSION=0.18_python3.6.3
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles



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

# Run this first to see what versions are available
# PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --ignore-installed whatshap==
# 
#   ERROR: Could not find a version that satisfies the requirement whatshap== (from versions: 0.9, 0.10, 0.11, 0.12, 0.13, 0.14, 0.14.1, 0.15, 0.16, 0.17, 0.18)
# ERROR: No matching distribution found for whatshap==


PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --ignore-installed whatshap==0.18



# STDOUT:


# Collecting whatshap==0.18
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/0a/50/c9c89e7f3a59251a91e618165ccc2586b626643a4c59dfd8d1b32f9b6bbb/whatshap-0.18-cp36-cp36m-manylinux1_x86_64.whl (439kB)
#     100% |████████████████████████████████| 440kB 52kB/s
# Collecting pyfaidx>=0.5.5.2 (from whatshap==0.18)
#   Cache entry deserialization failed, entry ignored
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/d9/eb/bca4c916d2cde775b5127cef22f276142b01e89fc31fecd832ed996dc97e/pyfaidx-0.5.8.tar.gz
# Collecting networkx (from whatshap==0.18)
#   Cache entry deserialization failed, entry ignored
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/41/8f/dd6a8e85946def36e4f2c69c84219af0fa5e832b018c970e92f2ad337e45/networkx-2.4-py3-none-any.whl (1.6MB)
#     100% |████████████████████████████████| 1.6MB 629kB/s
# Collecting biopython>=1.73 (from whatshap==0.18)
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/83/3d/e0c8a993dbea1136be90c31345aefc5babdd5046cd52f81c18fc3fdad865/biopython-1.76-cp36-cp36m-manylinux1_x86_64.whl (2.3MB)
#     100% |████████████████████████████████| 2.3MB 186kB/s
# Collecting pysam>=0.15.0 (from whatshap==0.18)
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/25/7e/098753acbdac54ace0c6dc1f8a74b54c8028ab73fb027f6a4215487d1fea/pysam-0.15.4.tar.gz (1.6MB)
#     100% |████████████████████████████████| 1.6MB 469kB/s
# Collecting xopen>=0.5.0 (from whatshap==0.18)
#   Cache entry deserialization failed, entry ignored
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/73/e9/bc35fd93cb6af3a011e44463db468914448825aa659f7636e836b8488b03/xopen-0.8.4-py2.py3-none-any.whl
# Collecting PyVCF (from whatshap==0.18)
#   Cache entry deserialization failed, entry ignored
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/20/b6/36bfb1760f6983788d916096193fc14c83cce512c7787c93380e09458c09/PyVCF-0.6.8.tar.gz
# Collecting six (from pyfaidx>=0.5.5.2->whatshap==0.18)
#   Cache entry deserialization failed, entry ignored
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/65/eb/1f97cb97bfc2390a276969c6fae16075da282f5058082d4cb10c6c5c1dba/six-1.14.0-py2.py3-none-any.whl
# Collecting setuptools>=0.7 (from pyfaidx>=0.5.5.2->whatshap==0.18)
#   Cache entry deserialization failed, entry ignored
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/70/b8/b23170ddda9f07c3444d49accde49f2b92f97bb2f2ebc312618ef12e4bd6/setuptools-46.0.0-py3-none-any.whl (582kB)
#     100% |████████████████████████████████| 583kB 1.2MB/s
# Collecting decorator>=4.3.0 (from networkx->whatshap==0.18)
#   Cache entry deserialization failed, entry ignored
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/ed/1b/72a1821152d07cf1d8b6fce298aeb06a7eb90f4d6d41acec9861e7cc6df0/decorator-4.4.2-py2.py3-none-any.whl
# Collecting numpy (from biopython>=1.73->whatshap==0.18)
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/62/20/4d43e141b5bc426ba38274933ef8e76e85c7adea2c321ecf9ebf7421cedf/numpy-1.18.1-cp36-cp36m-manylinux1_x86_64.whl (20.1MB)
#     100% |████████████████████████████████| 20.2MB 55kB/s
# Building wheels for collected packages: pyfaidx, pysam, PyVCF
#   Running setup.py bdist_wheel for pyfaidx ... done
#   Stored in directory: /home/lmnp/knut0297/.cache/pip/wheels/58/ea/ee/59d4649b0fb82a0690bdeae834bc85891b306126bcc067e29f
#   Running setup.py bdist_wheel for pysam ... done
#   Stored in directory: /home/lmnp/knut0297/.cache/pip/wheels/88/6f/7a/16429edfbe722ee969c3bf080043409e5e33c1bca32d32cc09
#   Running setup.py bdist_wheel for PyVCF ... done
#   Stored in directory: /home/lmnp/knut0297/.cache/pip/wheels/81/91/41/3272543c0b9c61da9c525f24ee35bae6fe8f60d4858c66805d
# Successfully built pyfaidx pysam PyVCF
# Installing collected packages: six, setuptools, pyfaidx, decorator, networkx, numpy, biopython, pysam, xopen, PyVCF, whatshap
# Successfully installed PyVCF-0.6.8 biopython-1.76 decorator-4.4.2 networkx-2.4 numpy-1.18.1 pyfaidx-0.5.8 pysam-0.15.4 setuptools-46.0.0 six-1.14.0 whatshap-0.18 xopen-0.8.4
# You are using pip version 9.0.1, however version 20.0.2 is available.
# You should consider upgrading via the 'pip install --upgrade pip' command.
# 
# 





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
        puts stderr "\tThis module adds whatshap executable to your path."
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







