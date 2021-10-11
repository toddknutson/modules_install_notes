#!/bin/bash

# 2021-08-25



# https://github.com/facebookresearch/faiss/blob/master/INSTALL.md

# This library is needed for the GIANA TCRseq tool.


MODULE_NAME=faiss
VERSION=1.7.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION

wget https://github.com/facebookresearch/faiss/archive/refs/tags/v$VERSION.tar.gz

tar xvzf v$VERSION.tar.gz
cd $MODULES_DIR/$MODULE_NAME/$VERSION/faiss-1.7.1


deactivate
module purge
# MSI modules
module load gcc/8.2.0
module load mkl/2019/update1
# (cuda gives you "nvcc" program) 
module load cuda/11.2 #(gives you "nvcc")
module load swig/3.0.12_gcc8.2.0

# Todd's modules
module load /home/lmnp/knut0297/software/modulesfiles/cmake/3.21.1
module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10
# Activate python virtual env, which provides numpy, sklearn, etc.
. $HOME/software/python_venvs/giana/bin/activate




cmake -B $MODULES_DIR/$MODULE_NAME/$VERSION/build -S $MODULES_DIR/$MODULE_NAME/$VERSION/faiss-1.7.1 -DCMAKE_INSTALL_PREFIX=$MODULES_DIR/$MODULE_NAME/$VERSION/build -DCMAKE_CXX_COMPILER=$(which g++) -DCMAKE_C_COMPILER=$(which gcc) -DFAISS_ENABLE_GPU=ON -DFAISS_ENABLE_PYTHON=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DBLA_VENDOR=Intel10_64_dyn
cd $MODULES_DIR/$MODULE_NAME/$VERSION/build
make -j 12 CXX=$(which g++) CC=$(which gcc) faiss


cd $MODULES_DIR/$MODULE_NAME/$VERSION/build
make -j 12 swigfaiss
cd $MODULES_DIR/$MODULE_NAME/$VERSION/build/faiss/python
python setup.py install

cd $MODULES_DIR/$MODULE_NAME/$VERSION/build
make install




# Basic example
# Build test
cd $MODULES_DIR/$MODULE_NAME/$VERSION/build
make demo_ivfpq_indexing
# Run test
./demos/demo_ivfpq_indexing



# ---------------------------------------------------------------------
# Interactive example
# ---------------------------------------------------------------------

# From bash, activate python virtual env 
# Start python

# 
# import numpy as np
# d = 64                           # dimension
# nb = 100000                      # database size
# nq = 10000                       # nb of queries
# np.random.seed(1234)             # make reproducible
# xb = np.random.random((nb, d)).astype('float32')
# xb[:, 0] += np.arange(nb) / 1000.
# xq = np.random.random((nq, d)).astype('float32')
# xq[:, 0] += np.arange(nq) / 1000.
# 
# 
# 
# 
# import faiss                   # make faiss available
# index = faiss.IndexFlatL2(d)   # build the index
# print(index.is_trained)
# index.add(xb)                  # add vectors to the index
# print(index.ntotal)
# 
# 
# 
# 
# k = 4                          # we want to see 4 nearest neighbors
# D, I = index.search(xb[:5], k) # sanity check
# print(I)
# print(D)
# D, I = index.search(xq, k)     # actual search
# print(I[:5])                   # neighbors of the 5 first queries
# print(I[-5:])                  # neighbors of the 5 last queries



# RESULTS SHOULD BE THIS:
# [[ 381  207  210  477]
#  [ 526  911  142   72]
#  [ 838  527 1290  425]
#  [ 196  184  164  359]
#  [ 526  377  120  425]]
# 
# [[ 9900 10500  9309  9831]
#  [11055 10895 10812 11321]
#  [11353 11103 10164  9787]
#  [10571 10664 10632  9638]
#  [ 9628  9554 10036  9582]]


 
 
 



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

# MSI modules
module load gcc/8.2.0
module load mkl/2019/update1
module load cuda/11.2
module load swig/3.0.12_gcc8.2.0

# Todd's modules
module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10

if [ module-info mode load ] {
    puts stderr "* To use the faiss package (needed by GIANA), activate the python virtual environment: '. /home/lmnp/knut0297/software/python_venvs/giana/bin/activate', and then try 'python -c \\"import faiss\\"'"
}


EOF



# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<EOF
#%Module
set ModulesVersion "$VERSION"

EOF




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




