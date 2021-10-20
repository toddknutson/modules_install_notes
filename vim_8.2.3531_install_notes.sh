#!/bin/bash




MODULE_NAME=vim
VERSION=8.2.3531
VERSION_SHORT=82
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

# Include --with-x if you want clipboard support
# Compile with python support (needed for some plugins)


module purge
module load gcc/7.2.0
module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10

# Find the python config dir (i.e. contains config.c file)
python3.7m-config --configdir
# /panfs/roc/groups/0/lmnp/knut0297/software/modules/python3/3.7.10/build/lib/python3.7/config-3.7m-x86_64-linux-gnu



LDFLAGS="-rdynamic" ./configure \
--disable-xsmp \
--disable-gui \
--with-x \
--with-features=huge \
--enable-fail-if-missing \
--enable-largefile \
--enable-multibyte \
--enable-python3interp \
--with-python3-command="python" \
--with-python3-config-dir="/home/lmnp/knut0297/software/modules/python3/3.7.10/build/lib/python3.7/config-3.7m-x86_64-linux-gnu" \
--prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build


make -j 16
make test



make install






# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME


VIM_READLINK=$(readlink -e $MODULES_DIR/$MODULE_NAME/$VERSION/build/share/vim)


cat > $VERSION <<EOF
#%Module######################################################################

prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin"
setenv VIM "$VIM_READLINK"

# Only prints message when being loaded
if [ module-info mode load ] {
    puts stderr "An environment variable: VIM, has been set to: $VIM_READLINK"
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






# ---------------------------------------------------------------------
# For Todd only: Update my .bashrc with current version
# ---------------------------------------------------------------------

if [ $USER == "knut0297" ]
then
	# Find and replace with current $VERSION
	sed -i "s|$MODULES_DIR/$MODULE_NAME/.*/build/bin|$MODULES_DIR/$MODULE_NAME/$VERSION/build/bin|g" /home/lmnp/knut0297/.bashrc
	sed -i "s|$MODULES_DIR/$MODULE_NAME/.*/build/share/vim|$MODULES_DIR/$MODULE_NAME/$VERSION/build/share/vim|g" /home/lmnp/knut0297/.bashrc
fi


