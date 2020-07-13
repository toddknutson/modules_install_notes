# Install PIGZ for multithreaded compression

# INFO:
# https://www.peterdavehello.org/2015/02/use-multi-threads-to-compress-files-when-taring-something/

# on the lab node


cd /home/vdl/public/vdltools/1.0/software 

wget http://zlib.net/pigz/pigz-2.3.4.tar.gz

tar -xf pigz-2.3.4.tar.gz

cd pigz-2.3.4
make


# Add permissions
chmod -R a+r /home/vdl/public/vdltools/1.0/software/pigz-2.3.4
chmod a+x /home/vdl/public/vdltools/1.0/software/pigz-2.3.4
chmod a+r /home/vdl/public/vdltools/1.0/software/pigz_install_notes
chmod a+x /home/vdl/public/vdltools/1.0/software/pigz-2.3.4/pigz





# ---------------------------------------------------------------------
# EXAMPLE
# ---------------------------------------------------------------------

# Original command:
tar -czf tarball.tgz files
# New command:
tar -I pigz -cf tarball.tgz files




#######################################################################
# EXAMPLE
#######################################################################



# 2017-11-02


# pigz software 
# Parallel gzip!
# https://www.peterdavehello.org/2015/02/use-multi-threads-to-compress-files-when-taring-something/



MODULE_NAME=pigz
VERSION=2.3.4
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


#######################################################################
# Install in modules dir
#######################################################################


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


wget http://zlib.net/pigz/pigz-2.3.4.tar.gz
tar -xf pigz-2.3.4.tar.gz

cd pigz-2.3.4
make


mkdir bin
mv pigz bin/
mv unpigz bin/



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
        puts stderr "\tThis module adds pigz to your path."
}

# NOTE: 
# The following items are added to the PATH in order (top to bottom of file). Thus, when you
# prepend the path with a new item, each item afterwards also gets prepended. Thus, the last 
# item in this file will be the "first" item in your PATH list, and will be the default program.


# Create a variable for this module's bin location
set BASEDIR "/home/lmnp/knut0297/software/modules/pigz/2.3.4/pigz-2.3.4/bin"
prepend-path PATH $BASEDIR



ENDOFMESSAGE






# Set the version
cat > .version <<'ENDOFMESSAGE'
#%Module
set ModulesVersion "2.3.4"

ENDOFMESSAGE





