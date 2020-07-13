# 2017-10-16


# KMC software 
# As part of Iterative Virus Assembler (IVA) installation, I need to install KMC


MODULE_NAME=kmc
VERSION=2.1.1
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget http://sun.aei.polsl.pl/kmc/download-2.1.1/linux/kmc
wget http://sun.aei.polsl.pl/kmc/download-2.1.1/linux/kmc_dump


# Update permissions
chmod -R a+r $MODULES_DIR/$MODULE_NAME
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION





#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds kmc to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/kmc/2.1.1"

# ---------------------------------------------------------------------	
# Add items to PATH
# ---------------------------------------------------------------------

prepend-path PATH $BASEDIR





ENDOFMESSAGE













