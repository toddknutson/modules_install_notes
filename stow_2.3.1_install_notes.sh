#!/bin/bash

# 2021-10-16

# https://www.gnu.org/software/stow/


MODULE_NAME=stow
VERSION=2.3.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles



#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION

wget https://ftp.gnu.org/gnu/stow/stow-${VERSION}.tar.gz

tar xvzf stow-${VERSION}.tar.gz
cd $MODULES_DIR/$MODULE_NAME/$VERSION/stow-${VERSION}


module load gcc/7.2.0
module load perl/modules.centos7.5.26.1



./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build
make -j 16 
make install prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build 






# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/bin
prepend-path LD_LIBRARY_PATH $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib
prepend-path INCLUDE $MODULES_DIR/$MODULE_NAME/$VERSION/build/include
prepend-path PERL5LIB $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/site_perl/5.26.1
prepend-path PERLLIB $MODULES_DIR/$MODULE_NAME/$VERSION/build/lib/site_perl/5.26.1

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






# ---------------------------------------------------------------------
# How to set up dotfiles management
# ---------------------------------------------------------------------

# http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html





