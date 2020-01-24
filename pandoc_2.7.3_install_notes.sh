# 2020-01-24


#######################################################################
# SUCCESS
#######################################################################



MODULE_NAME=pandoc
VERSION=2.7.3
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################

# If dir already exists, delete it
if [ -d "$MODULES_DIR/$MODULE_NAME/$VERSION" ]; then rm -Rf $MODULES_DIR/$MODULE_NAME/$VERSION; fi

mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# RStudio hosts compiled versions of pandoc on their website. Download one of them instead of compiling. 
# https://github.com/rstudio/rstudio/blob/4949a5187dd49f100d324bedfc2c596caeba9f46/dependencies/common/install-pandoc
# https://github.com/rstudio/rstudio/blob/master/dependencies/common/install-pandoc
PANDOC_VERSION="2.7.3"
PANDOC_URL_BASE="https://s3.amazonaws.com/rstudio-buildtools/pandoc/${PANDOC_VERSION}"
FILE=pandoc-${PANDOC_VERSION}-linux.tar.gz
echo ${PANDOC_URL_BASE}/${FILE}
wget ${PANDOC_URL_BASE}/${FILE}



tar xvf pandoc-2.7.3-linux.tar.gz


cd pandoc-2.7.3/bin
./pandoc --version
# pandoc 2.7.3
# Compiled with pandoc-types 1.17.5.4, texmath 0.11.2.2, skylighting 0.8.1
# Default user data directory: /home/lmnp/knut0297/.local/share/pandoc or /home/lmnp/knut0297/.pandoc








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
        puts stderr "\tThis module adds pandoc to your path."
}


# Update the necessary shell environment variables to make the software work
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/pandoc-2.7.3/bin"




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




