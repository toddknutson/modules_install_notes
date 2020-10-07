
# Software Install Notes

Todd Knutson


## Introduction


This directory contains text files that can be helpful when trying to install various software modules in your home directory on MSI (i.e. without root access). Generally, these files are bash scripts, but they should definitely be run interactively, line-by-line, so any issues can be identified immediately.

>The exact code in these notes are specific to my software directory organization and will need to be edited if someone else tries to use them.


I have set up multiple personal (my home dir) software modules using the [Environment modules](http://modules.sourceforge.net) system. My software modules are organized into the following dirs, within in my home directory (`/home/lmnp/knut0297`) on the MSI panasas primary storage:

	/home/lmnp/knut0297/software/modules/
	/home/lmnp/knut0297/software/modulesfiles/
	/home/lmnp/knut0297/software/modules_install_notes/
	
The `/home/lmnp/knut0297/software/modules_install_notes/` is this directory. Using any particular install note, you should be able to download and install software inside the `/home/lmnp/knut0297/software/modules/` directory. Then, a "modulefile" is created and stored in the `/home/lmnp/knut0297/software/modulesfiles/` directory. This modulefile contains the instructions for how your environment is modified when loading the module. 



Everything in the `/home/lmnp/knut0297/software` directory should be world `u+g+o` readable and executable (dirs and executable files). Thus, anyone on the MSI system can use these software installations.


## How to use these install notes?

Copy the note to your system and edit the note as necessary. 


## How to just load my installed software modules?

You can load these modules explicitly by calling the full path to the modulefile. For example, to load my `rsync` ver 3.1.2 module, run:

	module load /home/lmnp/knut0297/software/modulesfiles/rsync/3.1.2

This will allow you to run software installed in my `/home/lmnp/knut0297/software/modules/` directory. To see how your enviroment will be changed after loading the modulefile, you can run the `module display` command. For example:

	module display /home/lmnp/knut0297/software/modulesfiles/rsync/3.1.2












## Version control
Only the install notes source code is being tracked using git (not any input/output files, etc.). The code is synced with GitHub at the following location: 
[https://github.umn.edu/knut0297org/modules_install_notes](https://github.umn.edu/knut0297org/modules_install_notes)



