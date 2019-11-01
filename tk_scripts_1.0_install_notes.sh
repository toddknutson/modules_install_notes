# 2017-10-31

# These are Todd's scripts, either created by Todd or modified by Todd.



MODULE_NAME=tk_scripts
VERSION=1.0
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


mkdir bin
cd bin
cp -a /panfs/roc/groups/0/lmnp/knut0297/software/scripts_todd/* .



echo "Change-Log" >> $MODULES_DIR/$MODULE_NAME/changelog.txt
echo "["`date`"] Initial setup." >> $MODULES_DIR/$MODULE_NAME/changelog.txt


# Update permissions
chmod -R a+r $MODULES_DIR/$MODULE_NAME
find $MODULES_DIR/$MODULE_NAME -type d -exec chmod a+x {} \;
chmod -R a+x $MODULES_DIR/$MODULE_NAME/$VERSION/bin




#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds tk_scripts to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/tk_scripts/1.0/bin"
prepend-path PATH $BASEDIR



ENDOFMESSAGE






# Set the version
cat > .version <<'ENDOFMESSAGE'
#%Module
set ModulesVersion "1.0"

ENDOFMESSAGE





