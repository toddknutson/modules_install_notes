# 2017-10-16


# Taxonomer software 
# https://github.com/Yandell-Lab/taxonomer_0.5
# nucleotide and protein based kmer taxonomer tool


MODULE_NAME=taxonomer
VERSION=0.5
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# This current code had 20 commits past version 0.5
git clone https://github.com/Yandell-Lab/taxonomer_0.5.git




# The compiler requires:
module load python2/2.7.12_anaconda4.2
module load biopython


cd $MODULES_DIR/$MODULE_NAME/$VERSION/taxonomer_0.5/taxonomer

# Install
rm scripts/cython/*.so
rm scripts/cython/*.c
python setup.py build_ext --inplace



