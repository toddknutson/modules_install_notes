#!/bin/bash




MODULE_NAME=vim
VERSION=8.2.4502
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
# Edit the Makefile or use command line args to confgure


# Include --with-x if you want system clipboard support
# Compile with python support (needed for some plugins)


# Remove any hardcode vim paths or variables before installing new vim
PATH=$(echo "$PATH" | sed -e 's/\/home\/lmnp\/knut0297\/software\/modules\/vim\/8.2.3531\/build\/bin://')
unset $VIM


module purge
module load /home/lmnp/knut0297/software/modulesfiles/python3/3.7.10
module load /home/lmnp/knut0297/software/modulesfiles/xorg_util_macros/1.19.3
module load /home/lmnp/knut0297/software/modulesfiles/xextproto/7.3.0
module load /home/lmnp/knut0297/software/modulesfiles/xtrans/1.4.0
module load /home/lmnp/knut0297/software/modulesfiles/libx11/1.7.3.1
module load /home/lmnp/knut0297/software/modulesfiles/imake/1.0.8
module load gcc/8.2.0

# Where is the X11 library
ldconfig -p | grep libX11


# Find the python config dir (i.e. contains config.c file)
python3.7m-config --configdir
# /panfs/roc/groups/0/lmnp/knut0297/software/modules/python3/3.7.10/build/lib/python3.7/config-3.7m-x86_64-linux-gnu



CFLAGS="-O2 -g" LDFLAGS="-rdynamic" ./configure \
--disable-xsmp \
--disable-gui \
--with-x \
--with-features=huge \
--enable-fail-if-missing \
--enable-largefile \
--enable-multibyte \
--disable-canberra \
--disable-netbeans \
--enable-python3interp \
--with-python3-command="python" \
--with-python3-config-dir="/home/lmnp/knut0297/software/modules/python3/3.7.10/build/lib/python3.7/config-3.7m-x86_64-linux-gnu" \
--with-compiledby="Todd P. Knutson <knut0297@umn.edu>" \
--prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/build


make -j 64 
make test
make install




# Test startuptime
vim --startuptime startuptime.log
# Second column shows how long each event takes
# setup clipboard seems to take the most time, due to connecting with X11 server
# Open vim without X11
vim -X --startuptime startuptime_noX11.log
# If you don't need to use the system clipboard register, start vim with -X



# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME


cat > $VERSION <<EOF
#%Module######################################################################

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
fi


