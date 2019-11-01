
# 2017-11-02


# seqtk software 
# https://github.com/lh3/seqtk



MODULE_NAME=seqtk
VERSION=1.2-r94
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget https://github.com/lh3/seqtk/archive/v1.2.tar.gz
tar -xzf v1.2.tar.gz


cd seqtk-1.2
make

mkdir bin
mv seqtk bin/



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
        puts stderr "\tThis module adds seqtk to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
prepend-path PATH "/home/lmnp/knut0297/software/modules/seqtk/1.2-r94/seqtk-1.2/bin"



ENDOFMESSAGE






# Set the version
cat > .version <<'ENDOFMESSAGE'
#%Module
set ModulesVersion "1.2-r94"

ENDOFMESSAGE





