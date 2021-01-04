#!/bin/bash




MODULE_NAME=vim
VERSION=8.2.2301
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/build
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://github.com/vim/vim/archive/v${VERSION}.tar.gz
tar xvzf v${VERSION}.tar.gz



cd $MODULES_DIR/$MODULE_NAME/$VERSION/vim-${VERSION}

# See src/INSTALL for details
# Edit the Makefile

#CONF_OPT_XSMP = --disable-xsmp
#CONF_OPT_GUI = --disable-gui
#CONF_OPT_X = --without-x
#CONF_OPT_FEAT = --with-features=huge



module purge
module load gcc/7.2.0

./configure \
--disable-xsmp \
--disable-gui \
--without-x \
--with-features=huge \
--prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build


# See global vimrc: 
# /etc/vimrc
# /usr/share/vim
# make VIMRCLOC=/etc VIMRUNTIMEDIR=/usr/share/vim MAKE="make -e"

make
make test
# Executed:  3714 Tests
#  Skipped:    72 Tests
#   FAILED:     4 Tests
  
  
make install






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
        puts stderr "\tThis module adds $MODULE_NAME $VERSION to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"


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
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory






# ---------------------------------------------------------------------
# For Todd only: Update my .bashrc with current version
# ---------------------------------------------------------------------

if [ $USER == "knut0297" ]
then
	# Find and replace with current $VERSION
	sed "s|$MODULES_DIR/$MODULE_NAME/.*/build/bin|$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin|g" /home/lmnp/knut0297/.bashrc
fi





