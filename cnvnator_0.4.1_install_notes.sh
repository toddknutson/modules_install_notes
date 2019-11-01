#!/bin/bash

# 2019-09-10


#######################################################################
# SUCCESS -- 
#######################################################################






MODULE_NAME=cnvnator
VERSION=0.4.1
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



# Get the tarball
# Downloaded on 2019-09-10
# SHA https://github.com/abyzovlab/CNVnator/commit/b1f6c919ff7603606c74c07f8a5259f483d5d076
# I ran into this issue https://github.com/abyzovlab/CNVnator/issues/166
# when trying to install the release 0.4.1 version.
git clone https://github.com/abyzovlab/CNVnator.git
tar czf CNVnator.tar.gz CNVnator



module purge
module load zlib/1.2.8
module load root/6.06.06
module load readline/8.0
module unload   gcc/4.9.2
module load     gcc/4.9.2

cd CNVnator
ln -s /home/lmnp/knut0297/software/modules/samtools/1.2/samtools-1.2 samtools


make LIBS="-lcrypto"


# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################


# Create a help message for the module
# e.g. 
# module help <module_name>

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds cnvnator executable to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/CNVnator"
module load root/6.06.06


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


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory









