#!/bin/bash

# 2019-05-02


#######################################################################
# SUCCESSFUL INSTALL and TESTED -
#######################################################################



# SVanalyzer
# https://github.com/Martinsos/edlib/releases





MODULE_NAME=svanalyzer
VERSION=0.24
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# module load gcc/8.2.0
# module load cmake/3.10.2

module load edlib/1.2.4
module load perl/5.26.1
module load perl/modules.centos7.5.26.1
module load samtools/1.9
module load mummer
module load bedtools



# Get executable
# 2019-05-02 -- 6 commits past 0.24 release
git clone git://github.com/nhansen/SVanalyzer.git

cd SVanalyzer

perl Build.PL --install_base $MODULES_DIR/$MODULE_NAME/$VERSION

./Build
./Build test
./Build install



# NOTE: These might also be needed to run the tool??
# module load edlib/1.2.4
# module load perl/5.26.1
# module load perl/modules.centos7.5.26.1
# module load samtools/1.9
# module load mummer
# module load bedtools 





# ---------------------------------------------------------------------
# Create the modulefile
# ---------------------------------------------------------------------

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<ENDOFMESSAGE
#%Module######################################################################


# Create a help message for the module
# e.g. 
# module help <module_name>

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds SVanalyzer executable to your path."
}


# Update the necessary shell environment variables to make the software work
module load edlib/1.2.4
module load perl/5.26.1
module load perl/modules.centos7.5.26.1
module load samtools/1.9
module load mummer/3.23.CentOS7
module load bedtools/2.27.1
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"
prepend-path LD_LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/lib"
prepend-path PERL5LIB "$MODULES_DIR/$MODULE_NAME/$VERSION/lib/perl5"
prepend-path MANPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/man"


ENDOFMESSAGE





# ---------------------------------------------------------------------
# Create the modulefile default version
# ---------------------------------------------------------------------


# Set the version
cat > .version <<ENDOFMESSAGE
#%Module
set ModulesVersion "$VERSION"

ENDOFMESSAGE






# ---------------------------------------------------------------------
# Update permissions (if you want to share the module)
# ---------------------------------------------------------------------


# Make all directories readable and executable
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rxs

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory




