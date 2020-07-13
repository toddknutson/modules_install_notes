# 2018-05-03

# annovar 2018-04-16 version
# annotation of seq variants


# Links:
# http://annovar.openbioinformatics.org/en/latest/user-guide/download/



MODULE_NAME=annovar
VERSION=20180416
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION



# You need to register online and use a special download link.
# Do this, then upload the data to this module

# These are just perl scripts, do not need to make install

# Make the perl scripts executable
find $MODULES_DIR/$MODULE_NAME -name "*.pl" -print0 | xargs -0 chmod u+rx




# Download databases
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar refGene humandb2/
annotate_variation.pl -buildver hg19 -downdb cytoBand humandb2/
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar exac03 humandb2/ 
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar avsnp147 humandb2/ 
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar dbnsfp30a humandb2/









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
        puts stderr "\tThis module adds annnovar to your path."
}


# Example usage
# Use --vcfinput to get a VCF output and a text file
# table_annovar.pl example.vcf /panfs/roc/groups/0/lmnp/knut0297/software/modules/annovar/20180416/annovar/humandb2/ --vcfinput -buildver hg19 -out tumor_normal_pon_gnomAD_filtered -remove -protocol refGene,cytoBand,exac03,avsnp147,dbnsfp30a -operation gx,r,f,f,f -nastring . -polish -xref /panfs/roc/groups/0/lmnp/knut0297/software/modules/annovar/20180416/annovar/example/gene_xref.txt


prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/annovar"




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





# Make all directories (or executable files) readable and executable
find $MODULES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx
find $MODULES_DIR/$MODULE_NAME -executable -print0 | xargs -0 chmod a+rx
find $MODULESFILES_DIR/$MODULE_NAME -type d -print0 | xargs -0 chmod a+rx

# Make all files readable
find $MODULES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r
find $MODULESFILES_DIR/$MODULE_NAME -type f -print0 | xargs -0 chmod a+r







