#!/bin/bash

# Install date:
# 2020-05-05


#######################################################################
# EXAMPLE
#######################################################################


# annovar 2019-10-24 version
# annotation of seq variants


# Links:
# http://annovar.openbioinformatics.org/en/latest/user-guide/download/



MODULE_NAME=annovar
VERSION=20191024
MODULES_DIR=$HOME/software/modules
MODULESFILES_DIR=$HOME/software/modulesfiles


# ---------------------------------------------------------------------
# Create the module
# ---------------------------------------------------------------------


mkdir -p $MODULES_DIR/$MODULE_NAME/$VERSION
cd $MODULES_DIR/$MODULE_NAME/$VERSION


# https://doc-openbio.readthedocs.io/projects/annovar/en/latest/user-guide/download/

# You need to register online and use a special download link that gets sent by email.
# Download the files, and then upload them to this module location.

# These are just perl scripts, do not need to make install

# 
# Here is the link to download ANNOVAR: http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz
# 
# Please cite ANNOVAR paper in your publication: Wang K, Li M, Hakonarson H. ANNOVAR: Functional annotation of genetic variants from next-generation sequencing data, Nucleic Acids Research, 38:e164, 2010
# 





wget http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz
tar -xvzf annovar.latest.tar.gz
cd $MODULES_DIR/$MODULE_NAME/$VERSION/annovar

# Download another file
wget http://www.openbioinformatics.org/annovar/download/prepare_annovar_user.pl




# Make the perl scripts executable
find $MODULES_DIR/$MODULE_NAME -name "*.pl" -print0 | xargs -0 chmod u+rx



# ---------------------------------------------------------------------
# Download databases
# ---------------------------------------------------------------------
perl annotate_variation.pl -buildver hg19 -downdb -webfrom annovar exac03 humandb/ 
perl annotate_variation.pl -buildver hg19 -downdb -webfrom annovar avsnp150 humandb/ 
perl annotate_variation.pl -buildver hg19 -downdb -webfrom annovar dbnsfp35c humandb/




# ---------------------------------------------------------------------
# Download current COSMIC data
# ---------------------------------------------------------------------

# GRCh37 == hg19
# https://cancer.sanger.ac.uk/cosmic/download?genome=37
# https://cancer.sanger.ac.uk/cosmic/help/download


# Generate base64 encoded email and password -- BUT USE MY REAL EMAIL AND PASSWORD
# AUTH=$(echo "user@umn.edu:MYCOSMIDPASSWORD" | base64)


cd $MODULES_DIR/$MODULE_NAME/$VERSION/annovar/humandb

MY_JSON_URL=$(curl -H "Authorization: Basic ${AUTH}" https://cancer.sanger.ac.uk/cosmic/file_download/GRCh37/cosmic/v91/VCF/CosmicCodingMuts.vcf.gz)
DOWNLOAD_URL=$(echo $MY_JSON_URL | sed 's/{//g; s/}//g; s/"url"://g; s/"//g')
wget -O CosmicCodingMuts.vcf.gz "${DOWNLOAD_URL}"


MY_JSON_URL=$(curl -H "Authorization: Basic ${AUTH}" https://cancer.sanger.ac.uk/cosmic/file_download/GRCh37/cosmic/v91/VCF/CosmicCodingMuts.normal.vcf.gz)
DOWNLOAD_URL=$(echo $MY_JSON_URL | sed 's/{//g; s/}//g; s/"url"://g; s/"//g')
wget -O CosmicCodingMuts.normal.vcf.gz "${DOWNLOAD_URL}"



MY_JSON_URL=$(curl -H "Authorization: Basic ${AUTH}" https://cancer.sanger.ac.uk/cosmic/file_download/GRCh37/cosmic/v91/CosmicMutantExport.tsv.gz)
DOWNLOAD_URL=$(echo $MY_JSON_URL | sed 's/{//g; s/}//g; s/"url"://g; s/"//g')
wget -O CosmicMutantExport.tsv.gz "${DOWNLOAD_URL}"


gzip -d -c CosmicCodingMuts.vcf.gz > CosmicCodingMuts.vcf
gzip -d -c CosmicCodingMuts.normal.vcf.gz > CosmicCodingMuts.normal.vcf
gzip -d -c CosmicMutantExport.tsv.gz > CosmicMutantExport.tsv



# ---------------------------------------------------------------------
# Build COSMIC database for annovar
# ---------------------------------------------------------------------

cd $MODULES_DIR/$MODULE_NAME/$VERSION/annovar/humandb

# Requires a compute node and >30 GB of RAM
perl ../prepare_annovar_user.pl -dbtype cosmic CosmicMutantExport.tsv -vcf CosmicCodingMuts.vcf > hg19_cosmic_v91.txt



# ---------------------------------------------------------------------
# Example usage
# ---------------------------------------------------------------------
# Use --vcfinput to get a VCF output and a text file
# table_annovar.pl example.vcf /home/lmnp/knut0297/software/modules/annovar/20191024/annovar/humandb/ --vcfinput -buildver hg19 -out outname -remove -protocol refGene,exac03,avsnp150,dbnsfp35c,cosmic -operation gx,r,f,f,f -nastring . -polish -xref /home/lmnp/knut0297/software/modules/annovar/20191024/annovar/example/gene_xref.txt


# annotate_variation.pl -filter -build hg19 -out ex4 -dbtype cosmic91 ex4.avinput humandb/



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
prepend-path PATH "$MODULES_DIR/$MODULE_NAME/$VERSION/annovar"
setenv ANNOVAR_HUMANDB "$MODULES_DIR/$MODULE_NAME/$VERSION/annovar/humandb"

# Only prints message when being loaded
if [ module-info mode load ] {
 	puts stderr "An environment variable: \\\$ANNOVAR_HUMANDB, has been set that points to a directory containing Annovar human databases."
}


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







