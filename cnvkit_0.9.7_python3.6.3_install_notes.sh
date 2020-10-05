#!/bin/bash

# 2020-09-29


#######################################################################
# 
#######################################################################



MODULE_NAME=cnvkit
VERSION=0.9.7_python3.6.3
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



PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/build pip install --user --ignore-installed cnvkit==0.9.7



# STDOUT:
# 
# Collecting cnvkit==0.9.7
# 
#   Downloading https://files.pythonhosted.org/packages/67/f2/8989d8ed3163f78b3c8d524f97c9ce3b2d670f76ed17a8473347584d5d65/CNVkit-0.9.7.tar.gz (169kB)
#     100% |████████████████████████████████| 174kB 1.7MB/s
# Collecting biopython>=1.62 (from cnvkit==0.9.7)
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/76/02/8b606c4aa92ff61b5eda71d23b499ab1de57d5e818be33f77b01a6f435a8/biopython-1.78-cp36-cp36m-manylinux1_x86_64.whl (2.3MB)
#     100% |████████████████████████████████| 2.3MB 347kB/s
# Collecting pomegranate>=0.9.0 (from cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/3e/89/4de2e019923ec0814394d0261fa6577643805e0a9a05e51e6c393f6837fd/pomegranate-0.13.4-cp36-cp36m-manylinux1_x86_64.whl (12.6MB)
#     100% |████████████████████████████████| 12.6MB 68kB/s
# Collecting matplotlib>=1.3.1 (from cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/cd/d6/8c4dfb23151d5a494c66ebbfdb5c8c433b44ec07fae52da5939fcda0943f/matplotlib-3.3.2-cp36-cp36m-manylinux1_x86_64.whl (11.6MB)
#     100% |████████████████████████████████| 11.6MB 77kB/s
# Collecting numpy>=1.9 (from cnvkit==0.9.7)
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/b8/e5/a64ef44a85397ba3c377f6be9c02f3cb3e18023f8c89850dd319e7945521/numpy-1.19.2-cp36-cp36m-manylinux1_x86_64.whl (13.4MB)
#     100% |████████████████████████████████| 13.4MB 32kB/s
# Collecting pandas>=0.23.3 (from cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/1c/11/e1f53db0614f2721027aab297c8afd2eaf58d33d566441a97ea454541c5e/pandas-1.1.2-cp36-cp36m-manylinux1_x86_64.whl (10.5MB)
#     100% |████████████████████████████████| 10.5MB 16kB/s
# Collecting pyfaidx>=0.4.7 (from cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/09/91/10e16d419aa1fd8d2889b70843989640f9b88f10a792b6c73da0ebfd1966/pyfaidx-0.5.9.1.tar.gz
# Collecting pysam>=0.10.0 (from cnvkit==0.9.7)
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/87/a1/73e80a7a873f3fb0e52d368a4343eb9882b737c932b95020d82251f1087e/pysam-0.16.0.1-cp36-cp36m-manylinux1_x86_64.whl (9.9MB)
#     100% |████████████████████████████████| 10.0MB 85kB/s
# Collecting reportlab>=3.0 (from cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/db/99/677d3a607b18d8f529c518b6f158a0493fbfb93142c1841bbde6cae264db/reportlab-3.5.51-cp36-cp36m-manylinux1_x86_64.whl (2.6MB)
#     100% |████████████████████████████████| 2.6MB 279kB/s
# Collecting scikit-learn (from cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/5c/a1/273def87037a7fb010512bbc5901c31cfddfca8080bc63b42b26e3cc55b3/scikit_learn-0.23.2-cp36-cp36m-manylinux1_x86_64.whl (6.8MB)
#     100% |████████████████████████████████| 6.8MB 118kB/s
# Collecting scipy>=0.15.0 (from cnvkit==0.9.7)
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/2b/a8/f4c66eb529bb252d50e83dbf2909c6502e2f857550f22571ed8556f62d95/scipy-1.5.2-cp36-cp36m-manylinux1_x86_64.whl (25.9MB)
#     100% |████████████████████████████████| 25.9MB 40kB/s
# Collecting pyyaml (from pomegranate>=0.9.0->cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz (269kB)
#     100% |████████████████████████████████| 276kB 49kB/s
# Collecting joblib>=0.9.0b4 (from pomegranate>=0.9.0->cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/51/dd/0e015051b4a27ec5a58b02ab774059f3289a94b0906f880a3f9507e74f38/joblib-0.16.0-py3-none-any.whl (300kB)
#     100% |████████████████████████████████| 307kB 1.5MB/s
# Collecting networkx>=2.0 (from pomegranate>=0.9.0->cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/9b/cd/dc52755d30ba41c60243235460961fc28022e5b6731f16c268667625baea/networkx-2.5-py3-none-any.whl (1.6MB)
#     100% |████████████████████████████████| 1.6MB 482kB/s
# Collecting cycler>=0.10 (from matplotlib>=1.3.1->cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/f7/d2/e07d3ebb2bd7af696440ce7e754c59dd546ffe1bbe732c8ab68b9c834e61/cycler-0.10.0-py2.py3-none-any.whl
# Collecting pyparsing!=2.0.4,!=2.1.2,!=2.1.6,>=2.0.3 (from matplotlib>=1.3.1->cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/8a/bb/488841f56197b13700afd5658fc279a2025a39e22449b7cf29864669b15d/pyparsing-2.4.7-py2.py3-none-any.whl (67kB)
#     100% |████████████████████████████████| 71kB 1.8MB/s
# Collecting python-dateutil>=2.1 (from matplotlib>=1.3.1->cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/d4/70/d60450c3dd48ef87586924207ae8907090de0b306af2bce5d134d78615cb/python_dateutil-2.8.1-py2.py3-none-any.whl (227kB)
#     100% |████████████████████████████████| 235kB 1.8MB/s
# Collecting kiwisolver>=1.0.1 (from matplotlib>=1.3.1->cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/ae/23/147de658aabbf968324551ea22c0c13a00284c4ef49a77002e91f79657b7/kiwisolver-1.2.0-cp36-cp36m-manylinux1_x86_64.whl (88kB)
#     100% |████████████████████████████████| 92kB 2.2MB/s
# Collecting certifi>=2020.06.20 (from matplotlib>=1.3.1->cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/5e/c4/6c4fe722df5343c33226f0b4e0bb042e4dc13483228b4718baf286f86d87/certifi-2020.6.20-py2.py3-none-any.whl (156kB)
#     100% |████████████████████████████████| 163kB 2.1MB/s
# Collecting pillow>=6.2.0 (from matplotlib>=1.3.1->cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/30/bf/92385b4262178ca22b34f82e0e09c2922eb351fe39f3cc7b8ba9ea555b41/Pillow-7.2.0-cp36-cp36m-manylinux1_x86_64.whl (2.2MB)
#     100% |████████████████████████████████| 2.2MB 22kB/s
# Collecting pytz>=2017.2 (from pandas>=0.23.3->cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/4f/a4/879454d49688e2fad93e59d7d4efda580b783c745fd2ec2a3adf87b0808d/pytz-2020.1-py2.py3-none-any.whl (510kB)
#     100% |████████████████████████████████| 512kB 77kB/s
# Collecting six (from pyfaidx>=0.4.7->cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/ee/ff/48bde5c0f013094d729fe4b0316ba2a24774b3ff1c52d924a8a4cb04078a/six-1.15.0-py2.py3-none-any.whl
# Collecting setuptools>=0.7 (from pyfaidx>=0.4.7->cnvkit==0.9.7)
#   Cache entry deserialization failed, entry ignored
#   Downloading https://files.pythonhosted.org/packages/44/a6/7fb6e8b3f4a6051e72e4e2218889351f0ee484b9ee17e995f5ccff780300/setuptools-50.3.0-py3-none-any.whl (785kB)
#     100% |████████████████████████████████| 788kB 870kB/s
# Collecting threadpoolctl>=2.0.0 (from scikit-learn->cnvkit==0.9.7)
#   Downloading https://files.pythonhosted.org/packages/f7/12/ec3f2e203afa394a149911729357aa48affc59c20e2c1c8297a60f33f133/threadpoolctl-2.1.0-py3-none-any.whl
# Collecting decorator>=4.3.0 (from networkx>=2.0->pomegranate>=0.9.0->cnvkit==0.9.7)
#   Using cached https://files.pythonhosted.org/packages/ed/1b/72a1821152d07cf1d8b6fce298aeb06a7eb90f4d6d41acec9861e7cc6df0/decorator-4.4.2-py2.py3-none-any.whl
# Building wheels for collected packages: cnvkit, pyfaidx, pyyaml
#   Running setup.py bdist_wheel for cnvkit ... done
#   Stored in directory: /home/lmnp/knut0297/.cache/pip/wheels/ff/27/87/de6231ad75761075aaf60323f13a7aacd5853876ef8bc35465
#   Running setup.py bdist_wheel for pyfaidx ... done
#   Stored in directory: /home/lmnp/knut0297/.cache/pip/wheels/57/cd/73/34f6bb5e5a8a4a014ee5bd14a951e12617bd7a4e10cb0df252
#   Running setup.py bdist_wheel for pyyaml ... -
# done
#   Stored in directory: /home/lmnp/knut0297/.cache/pip/wheels/a7/c1/ea/cf5bd31012e735dc1dfea3131a2d5eae7978b251083d6247bd
# Successfully built cnvkit pyfaidx pyyaml
# Installing collected packages: numpy, biopython, scipy, pyyaml, joblib, decorator, networkx, pomegranate, six, cycler, pyparsing, python-dateutil, kiwisolver, certifi, pillow, matplotlib, pytz, pandas, setuptools, pyfaidx, pysam, reportlab, threadpoolctl, scikit-learn, cnvkit
# Successfully installed biopython-1.78 certifi-2020.6.20 cnvkit-0.9.7 cycler-0.10.0 decorator-4.4.2 joblib-0.16.0 kiwisolver-1.2.0 matplotlib-3.3.2 networkx-2.5 numpy-1.19.2 pandas-1.1.2 pillow-7.2.0 pomegranate-0.13.4 pyfaidx-0.5.9.1 pyparsing-2.4.7 pysam-0.16.0.1 python-dateutil-2.8.1 pytz-2020.1 pyyaml-5.3.1 reportlab-3.5.51 scikit-learn-0.23.2 scipy-1.5.2 setuptools-50.3.0 six-1.15.0 threadpoolctl-2.1.0
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







