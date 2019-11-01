# 2017-10-16

# Centrifuge classification software
# https://ccb.jhu.edu/software/centrifuge/



MODULE_NAME=centrifuge
VERSION=1.0.3-beta
MODULES_DIR=/home/lmnp/knut0297/software/modules
MODULESFILES_DIR=/home/lmnp/knut0297/software/modulesfiles


#######################################################################
# Install in modules
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# Download (17 commits past the 1.0.3-beta version release)
git clone https://github.com/infphilo/centrifuge.git

cd centrifuge

# Manually download kraken report script
wget https://raw.github.com/infphilo/centrifuge/master/centrifuge-kreport



make 







# link the executables to a bin directory
mkdir bin
cd bin
ln -s ../centrifuge centrifuge
ln -s ../centrifuge-class centrifuge-class
ln -s ../centrifuge-build centrifuge-build
ln -s ../centrifuge-build-bin centrifuge-build-bin
ln -s ../centrifuge-download centrifuge-download
ln -s ../centrifuge-inspect centrifuge-inspect
ln -s ../centrifuge-inspect-bin centrifuge-inspect-bin


# Update permissions for world
chmod a+rx $MODULES_DIR/$MODULE_NAME/$VERSION/centrifuge/centrifuge
chmod a+rx $MODULES_DIR/$MODULE_NAME/$VERSION/centrifuge/centrifuge-class
chmod a+rx $MODULES_DIR/$MODULE_NAME/$VERSION/centrifuge/centrifuge-build
chmod a+rx $MODULES_DIR/$MODULE_NAME/$VERSION/centrifuge/centrifuge-build-bin
chmod a+rx $MODULES_DIR/$MODULE_NAME/$VERSION/centrifuge/centrifuge-download
chmod a+rx $MODULES_DIR/$MODULE_NAME/$VERSION/centrifuge/centrifuge-inspect
chmod a+rx $MODULES_DIR/$MODULE_NAME/$VERSION/centrifuge/centrifuge-inspect-bin








#######################################################################
# Create the modulefile
#######################################################################

mkdir -p $MODULESFILES_DIR/$MODULE_NAME
cd $MODULESFILES_DIR/$MODULE_NAME




cat > $VERSION <<'ENDOFMESSAGE'
#%Module######################################################################

proc ModulesHelp { } {
        global version
        puts stderr "\tThis module adds centrifuge to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/centrifuge/1.0.3-beta/centrifuge/bin"
prepend-path PATH $BASEDIR

set centrifugehome "/home/lmnp/knut0297/software/modules/centrifuge/1.0.3-beta/centrifuge"
prepend-path CENTRIFUGE_HOME $centrifugehome







ENDOFMESSAGE






