# 2018-10-02


# fastaq
# https://github.com/sanger-pathogens/Fastaq/releases





MODULE_NAME=fastaq
VERSION=3.15.0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



wget https://github.com/sanger-pathogens/Fastaq/archive/v3.15.0.tar.gz
tar -xvzf v3.15.0.tar.gz



# ---------------------------------------------------------------------


# Install python 
# More info:
# http://stackoverflow.com/questions/2915471/install-a-python-package-into-a-different-directory-using-pip?rq=1

# Set up a folder for all python3 stuff
mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION/python3_stuff
cd $MODULES_DIR/$MODULE_NAME/$VERSION/Fastaq-3.15.0


module load python3/3.6.3_anaconda5.0.1

# Install using this command:
PYTHONUSERBASE=$MODULES_DIR/$MODULE_NAME/$VERSION/python3_stuff pip install --user --upgrade --ignore-installed $MODULES_DIR/$MODULE_NAME/$VERSION/Fastaq-3.15.0









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
        puts stderr "\tThis module adds python3 based fastaq 3.15.0 to your path."
}


# Update the necessary shell environment variables to make the software work
module load python3/3.6.3_anaconda5.0.1
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/python3_stuff/bin"
prepend-path PYTHONPATH "$MODULES_DIR/$MODULE_NAME/$VERSION/python3_stuff/lib/python3.4/site-packages"



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




