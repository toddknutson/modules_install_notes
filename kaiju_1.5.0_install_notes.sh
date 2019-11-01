# 2017-10-13


# Kaiju software 
# https://github.com/bioinformatics-centre/kaiju
# protein based kmer taxonomer


MODULE_NAME=kaiju
VERSION=1.5.0
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles


#######################################################################
# Install in modules
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# This current code had 16 commits past version 1.5.0
git clone https://github.com/bioinformatics-centre/kaiju.git

cd kaiju/src
make


# the executables will now be located in the newly created bin directory

# Update permissions
# add executable to world for binaries
chmod -R a+r $MODULES_DIR/$MODULE_NAME/$VERSION/kaiju/bin
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/kaiju/bin



#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds kaiju to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/kaiju/1.5.0/kaiju/bin"

# ---------------------------------------------------------------------	
# Add items to PATH
# ---------------------------------------------------------------------

prepend-path PATH $BASEDIR





ENDOFMESSAGE


