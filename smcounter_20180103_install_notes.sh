#!/bin/bash
# 2018-01-03


# smCounter software 
# https://github.com/xuchang116/smCounter
# UMI aware variant caller


MODULE_NAME=smcounter
VERSION=20180103
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


module load git
git clone https://github.com/xuchang116/smCounter.git


cd smCounter


# add python shebang to all python files
sed -i '1s/^/#!\/usr\/bin\/env python \n/' smCounter.py


# Update permissions
chmod -R a+r $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME -type d -exec chmod a+x {} \;
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/smCounter/{*.py,*.pyc,*.R}


# This software requires the pysam module. 

# remove the #! shebang line from the script 


#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds smCounter to your path."
}



# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/smcounter/20180103/smCounter"
prepend-path PATH $BASEDIR




ENDOFMESSAGE






# Set the version
cat > .version <<'ENDOFMESSAGE'
#%Module
set ModulesVersion "20180103"

ENDOFMESSAGE





