#!/bin/bash

# 2022-01-25

# Entrez Direct: E-utilities on the Unix Command Line
# https://www.ncbi.nlm.nih.gov/books/NBK179288/


# Useful for downloading files from NCBI



MODULE_NAME=edirect
VERSION=20220125
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

# This is an install script -- do not actually run this...
wget ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh

# This is the software package
wget ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz
tar xvf edirect.tar.gz
cd edirect


# There are a few programs that are platform specific. We will update with the Linux versions.
# determine current computer platform
osname=$(uname -s)
cputype=$(uname -m)
case "$osname-$cputype" in
  Linux-x86_64 )           plt=Linux ;;
  Darwin-x86_64 )          plt=Darwin ;;
  Darwin-*arm* )           plt=Silicon ;;
  CYGWIN_NT-* | MINGW*-* ) plt=CYGWIN_NT ;;
  Linux-*arm* )            plt=ARM ;;
esac

# fetch appropriate precompiled versions of xtract, rchive, and transmute
if [ -n "$plt" ]
then
  for exc in xtract rchive transmute
  do
    wget ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/"$exc.$plt.gz"
    gunzip -f "$exc.$plt.gz"
    chmod +x "$exc.$plt"
  done
fi









# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME





cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/edirect"

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







