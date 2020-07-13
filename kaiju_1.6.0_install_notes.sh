# 2018-02-13


# Kaiju software 
# https://github.com/bioinformatics-centre/kaiju
# protein based kmer taxonomer


MODULE_NAME=kaiju
VERSION=1.6.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# This current code had 0 commits past version 1.6.0 -- thus, it is the same as release 1.6.0
wget https://github.com/bioinformatics-centre/kaiju/releases/download/v1.6.0/kaiju-1.6.0-linux-x86_64.tar.gz

tar -xvf kaiju-1.6.0-linux-x86_64.tar.gz




# the executables will now be located in the newly created bin directory

######## NOTE:
# Make sure you go in and edit manually the makeDB.sh scripts, to make them download only, or build only.
# look for commented out lines in previous version of kaiju

# Update permissions
# add executable to world for binaries
chmod -R a+r $MODULES_DIR/$MODULE_NAME/$VERSION/kaiju-v1.6.0-linux-x86_64-static/bin
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/kaiju-v1.6.0-linux-x86_64-static/bin



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
set BASEDIR "/home/lmnp/knut0297/software/modules/kaiju/1.6.0/kaiju-v1.6.0-linux-x86_64-static/bin"

# ---------------------------------------------------------------------	
# Add items to PATH
# ---------------------------------------------------------------------

prepend-path PATH $BASEDIR





ENDOFMESSAGE








#######################################################################
# Set the version
#######################################################################
cd $MODULESFILES_DIR/$MODULE_NAME
cat > .version <<'ENDOFMESSAGE'
#%Module
set ModulesVersion "1.6.0"

ENDOFMESSAGE


