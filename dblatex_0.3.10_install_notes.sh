#!/bin/bash

# 2019-09-06


#######################################################################
# Sucess
#######################################################################






MODULE_NAME=dblatex
VERSION=0.3.10
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



# Get the tarball
wget https://sourceforge.net/projects/dblatex/files/dblatex/dblatex-0.3.10/dblatex-0.3.10.tar.bz2
tar xvjf dblatex-0.3.10.tar.bz2
cd dblatex-0.3.10


module purge
module load gcc/7.2.0
module load bzip2/1.0.6-gnu7.2.0_PIC
module load python2/2.7.15_anaconda
module load texlive/20131202
module load texinfo/6.5
export PYTHONUSERBASE="$MODULES_DIR/$MODULE_NAME/$VERSION"

python setup.py install --user










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
        puts stderr "\tThis module adds dblatex executable to your path."
}


# Update the necessary shell environment variables to make the software work
module load python2/2.7.15_anaconda
module load texlive/20131202
module load texinfo/6.5
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/lib/python2.7/site-packages"
prepend-path PYTHONUSERBASE "$MODULES_DIR/$MODULE_NAME/$VERSION"



EOF






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





