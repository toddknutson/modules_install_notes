# Install conda


# 2018-01-24

# INFO:
# https://conda.io/miniconda.html

# The software automatically updates to 4.4.7, so this is folder name I used.


MODULE_NAME=conda
VERSION=4.4.7-py36_0
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME
cd $MODULES_DIR/$MODULE_NAME


wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

# Install miniconda at the specified prefix
bash Miniconda3-latest-Linux-x86_64.sh -p /home/lmnp/knut0297/software/modules/conda/4.4.7-py36_0/


# Follow the prompts at the command line
# yes (agree to terms)
# <enter> (to install in default location)


# move the install script into the version diriectory
mv /home/lmnp/knut0297/software/modules/conda/Miniconda3-latest-Linux-x86_64.sh /home/lmnp/knut0297/software/modules/conda/4.4.7-py36_0/



# Update permissions
chmod -R a+r $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+x
find $MODULES_DIR/$MODULE_NAME -type f -executable -print0 | xargs -0 chmod a+x






#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds conda to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/conda/4.4.7-py36_0/bin"
prepend-path PATH $BASEDIR




ENDOFMESSAGE






# Set the version
cat > .version <<'ENDOFMESSAGE'
#%Module
set ModulesVersion "4.4.7-py36_0"

ENDOFMESSAGE





#######################################################################
# Create a default .condarc file if desired
#######################################################################

cat > ~/.condarc <<'ENDOFMESSAGE'
channels:
  - bioconda
  - r
  - defaults

ENDOFMESSAGE
  

