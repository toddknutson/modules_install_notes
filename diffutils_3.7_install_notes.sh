#!/bin/bash

# 2019-09-23


#######################################################################
#
#######################################################################






MODULE_NAME=diffutils
VERSION=3.7
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



# Get the tarball
wget https://ftp.gnu.org/gnu/diffutils/diffutils-3.7.tar.xz





tar xJvf diffutils-3.7.tar.xz
cd diffutils-3.7

module purge
module load gcc/7.2.0
module load zlib/1.2.11_gcc7.2.0

./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION
make 
make install





# Man pages
# Now there is a share dir, after above install
# Move the man files to the default man location
# https://askubuntu.com/questions/244809/how-do-i-manually-install-a-man-page-file




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
        puts stderr "\tThis module adds diff executable to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"
# Updating manpath is not necessary because man files are in default location for local software, relative to bin
# prepend-path MANPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/share/man"

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









