#!/bin/bash
# 2017-10-23


# Rsync software
# http://rsync.samba.org/download.html



MODULE_NAME=rsync
VERSION=3.1.2
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://www.samba.org/ftp/rsync/src/rsync-3.1.2.tar.gz
tar -xzf rsync-3.1.2.tar.gz


cd rsync-3.1.2
./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/rsync-3.1.2
make
make install


# Update permissions
chmod -R a+r $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME -type d -exec chmod a+x {} \;
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/rsync-3.1.2/bin





#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds rsync to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/rsync/3.1.2/rsync-3.1.2/bin"
prepend-path PATH $BASEDIR




ENDOFMESSAGE






# Set the version
cat > .version <<'ENDOFMESSAGE'
#%Module
set ModulesVersion "3.1.2"

ENDOFMESSAGE





