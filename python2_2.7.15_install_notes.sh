#!/bin/bash


# 2020-08-20
#######################################################################
# SUCCESS
#######################################################################


# Python 2
# https://tecadmin.net/install-python-2-7-on-centos-rhel/


MODULE_NAME=python2
VERSION=2.7.15
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION

wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz
tar xzvf Python-2.7.15.tgz

module purge
module load gcc/7.2.0
module load bzip2/1.0.6-gnu7.2.0_PIC


cd Python-2.7.15
./configure --enable-optimizations --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION
make altinstall



# ---------------------------------------------------------------------
# Create python alias
# ---------------------------------------------------------------------

cd $MODULES_DIR/$MODULE_NAME/$VERSION/bin
ln -s $MODULES_DIR/$MODULE_NAME/$VERSION/bin/python2.7 python
ln -s $MODULES_DIR/$MODULE_NAME/$VERSION/bin/python2.7 python2



# ---------------------------------------------------------------------
# Consider adding these to modulefile
# ---------------------------------------------------------------------

# Other environment variables:
# PYTHONSTARTUP: file executed on interactive startup (no default)
# PYTHONPATH   : ':'-separated list of directories prefixed to the
#                default module search path.  The result is sys.path.
# PYTHONHOME   : alternate <prefix> directory (or <prefix>:<exec_prefix>).
#                The default module search path uses <prefix>/pythonX.X.
# PYTHONCASEOK : ignore case in 'import' statements (Windows).
# PYTHONIOENCODING: Encoding[:errors] used for stdin/stdout/stderr.
# PYTHONHASHSEED: if this variable is set to 'random', the effect is the same
#    as specifying the -R option: a random value is used to seed the hashes of
#    str, bytes and datetime objects.  It can also be set to an integer
#    in the range [0,4294967295] to get hash values with a predictable seed.



# ---------------------------------------------------------------------
# Install PIP
# ---------------------------------------------------------------------

cd $MODULES_DIR/$MODULE_NAME/$VERSION
wget "https://bootstrap.pypa.io/get-pip.py"
chmod u+x get-pip.py
./bin/python2.7 get-pip.py --prefix=$MODULES_DIR/$MODULE_NAME/$VERSION





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
        puts stderr "\tThis module adds $MODULE_NAME $VERSION to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/bin"
prepend-path LD_LIBRARY_PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/lib"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/lib/python2.7/site-packages"

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







