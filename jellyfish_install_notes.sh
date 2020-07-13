#!/bin/bash
# 2017-10-16

# Jellyfish

# kmer counter software
# http://www.cbcb.umd.edu/software/jellyfish/
# Used to create custom Kraken database






MODULE_NAME=jellyfish
VERSION=1.1.11
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

# On the lab queue for WAN internet connection
wget http://www.cbcb.umd.edu/software/jellyfish/jellyfish-1.1.11.tar.gz
wget http://www.cbcb.umd.edu/software/jellyfish/jellyfish-manual-1.1.pdf
tar -xzvf jellyfish-1.1.11.tar.gz


cd jellyfish-1.1.11

# Create a bin directory inside the main program directory
mkdir bin

./configure --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION/jellyfish-1.1.11/bin
make



# Then make sure the following environment variables contain the correct
# paths:
# 
# PATH            -> /my/dir/bin
# LD_LIBRARY_PATH -> /my/dir/lib
# MANPATH         -> /my/dir/share/man
# PKG_CONFIG_PATH -> /my/dir/lib/pkgconfig
# 
# Only the PATH environment variables is necessary to run
# jellyfish. MANPATH is used by the man command. PKG_CONFIG_PATH and
# LD_LIBRARY_PATH are used to compile software against the jellyfish
# shared library.


# Update permissions
# add executable to world for binaries
chmod -R a+r $MODULES_DIR/$MODULE_NAME/$VERSION/jellyfish-1.1.11/bin
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/jellyfish-1.1.11/bin







#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds jellyfish k-mer counter to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.



# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/jellyfish/1.1.11/jellyfish-1.1.11/bin"

# ---------------------------------------------------------------------	
# Add items to PATH
# ---------------------------------------------------------------------

prepend-path PATH $BASEDIR





ENDOFMESSAGE






