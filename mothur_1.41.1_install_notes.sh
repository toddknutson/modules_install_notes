# 2018-12-20


#######################################################################
# FAILED
#######################################################################



# Mothur metagenomics software
# https://github.com/mothur/mothur/releases





MODULE_NAME=mothur
VERSION=1.41.1_plus6commits
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



# downloaded on 2018-12-20, 6 commits past release 1.41.1
git clone https://github.com/mothur/mothur.git

cd mothur

module purge
module load gcc/7.2.0
module load bzip2/1.0.6-gnu7.2.0_PIC
module load zlib/1.2.11_gcc7.2.0
module load boost/1.65.1/gnu-7.2.0
module load hdf5/hdf5-1.10.2-intel2018release-serial
module load python

# Update Makefile (Makefile_edited) entering hard coded paths to Boost and HDF5 library locations.
# BOOST_LIBRARY_DIR ?= "/panfs/roc/msisoft/boost/1.65.1/gnu-7.2.0/lib"
# BOOST_INCLUDE_DIR ?= "/panfs/roc/msisoft/boost/1.65.1/gnu-7.2.0/include"
# HDF5_LIBRARY_DIR ?= "/panfs/roc/msisoft/hdf5/hdf5-1.10.2-intel2018release-serial/lib"
# HDF5_INCLUDE_DIR ?= "/panfs/roc/msisoft/hdf5/hdf5-1.10.2-intel2018release-serial/include"


make -f Makefile_edited




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
        puts stderr "\tThis module adds megahit 1.1.3 to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/mothur"




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
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r

# Make all files, that are already executable, readable and executable
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+rx
# Note: there are no executable files in the modulesfiles directory




