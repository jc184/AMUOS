#!/bin/bash
# james chalmers bsc computing 08003323
# advanced multi user operating systems assignment
# shell script menu of simple system administration tasks using functions
# script to be run from a users home directory

# Variable values are set here:

ENTERPATH="Enter the file path if the file resides in a sub-directory. eg Documents/filename.txt"
NOTFOUND=" No such file. To re-enter, select option from the menu."
DATE=$(date)
FLNM="Please enter the filename you wish to"
ERROR="\e[1;31mError:\e[0m"
SUCCESS="\e[1;32mSuccess:\e[0m"
TRUE="\e[1;32mTrue:\e[0m"
FALSE="\e[1;31mFalse:\e[0m"
#source ~/.bash_profile #Check if this line is needed
#Path set here, so script will always run whatever user directory it is in:
export PATH=$PATH:$PWD 

clear

userOptions() {
	echo
	echo -e "   \e[1;32mAMUOS ASSIGNMENT MENU SYSTEM\e[0m"
	echo
	echo " 1. User's Home Directory"
	echo " 2. Choose a Directory to list its contents"
	echo " 3. Find a file"
	echo " 4. Edit a file"
	echo " 5. Copy a file to a Directory"
	echo " 6. Delete a file"
	echo " 7. Delete a directory"
	echo " 8. Show current date and time"
	echo " 9. List all running user processes"
	echo "10. Terminate a running process"
	echo "11. Quit the Menu"
	echo
	echo "Choose an option from [1 - 11]: "
	echo
}

listOptions() {
	echo
	echo -e "    \e[1;35mLIST OPTIONS\e[0m"
	echo
	echo " 1. List - simple"
	echo " 2. List - long format"
	echo " 3. List - long format, showing hidden files"
	echo " 4. List - recursive, showing subfolders and their contents"
	echo " 5. Quit the list menu"
	echo
	echo "Choose an option from [1 - 5]: "
	echo
}

listLoop() {
	while [ 1 ] 
	do
		listOptions
		read USERCHOICE
		case $USERCHOICE in

		1) ls --color=always  ;;

		2) ls -l --color=always  ;;

		3) ls -al --color=always  ;;

		4) ls -R --color=always  ;;

		5) break ;;

		*)

		echo -e $ERROR "$USERCHOICE is not a valid choice. Please select choice between 1 - 5 only";
		read enterKey ;;
		esac
	done
}


copytoFolder() {
	cp -ip "$FILETOCOPY" "$DESTDIR"; echo "The file has been copied to the specified directory"
}

displayUserHome() {
	echo; echo "Contents of user's home directory:"; echo; ls -l $HOME --color=always; echo
}

copyFile() {
	echo; echo "$FLNM copy and press [ENTER]: "
	echo $ENTERPATH
	read FILETOCOPY
	if [ -f "$FILETOCOPY" ]; then
		echo "File found"
		echo "Enter the name of the target directory and press [ENTER]: "
		read DESTDIR
			if [ ! -d "$DESTDIR" ]; then echo; 
			echo "Directory does not exist: creating new directory..... "; echo
				mkdir -p --verbose "$DESTDIR"; copytoFolder
			else copytoFolder
			fi
	else
		echo -e $ERROR $NOTFOUND
	fi; 
echo
}

findFile() {
	echo; echo "$FLNM find and press [ENTER]: "
	echo $ENTERPATH
	read FILENAME
	if [ -f "$FILENAME" ]; then
		echo -e $TRUE "A file of that name exists."
	else
		echo -e $FALSE $NOTFOUND
	fi
	echo
}

editFile() {
	while [ true ]
	do
		echo; echo "$FLNM edit and press [ENTER]. (Ctrl-C to exit): "
		echo $ENTERPATH
		read FILENAME
		echo "Filename: " "$FILENAME"
		if [ -f "$FILENAME" ]; then
			echo "File exists: Opening file for editing.... (Ctrl-K + X to save and exit)"
			echo
			joe "$FILENAME"
			break
		else
			echo -e $ERROR $NOTFOUND
			break
		fi
		echo
	done
}

delFile() {
	echo; echo "$FLNM delete and press [ENTER]: "
	echo $ENTERPATH
	read FILENAME
	if [ -f "$FILENAME" ]; then
		echo
		rm -iv "$FILENAME"
	else
		echo -e $ERROR $NOTFOUND
	fi
	echo
}

delDir() {
	echo; echo "Please enter the name of the directory you wish to delete. "
	echo "Enter the full path if it is a subdirectory eg Folder/Subfolder "
	read FOLDERNAME
	if [ "$(ls -A "$FOLDERNAME")" ]; then #checks if directory contains any files
		echo "$FOLDERNAME contains files." #check if this line needed
		rm -iR "$FOLDERNAME"
		echo
		echo -e $SUCCESS "Folder and contents deleted."
	else
		echo "$FOLDERNAME is empty." #check if this line needed
		rmdir "$FOLDERNAME" -p --verbose
		echo
		echo -e $SUCCESS "Folder deleted."
	fi
}

listDir() {
	echo; echo "Please enter the name of the directory to list: "
	read FOLDERNAME
	if [ -d "$FOLDERNAME" ]; then
		echo; cd "$FOLDERNAME"; listLoop; cd $HOME
	else
		echo
		echo -e $ERROR "Cannot find a directory of that name. Menu will refer to the current user's home directory instead."
		listLoop
		echo
	fi
	echo
}

showDate() {
	echo; echo -e "The current date and time is:" "\e[1;35m$DATE\e[0m"; echo
}

listProc() {
	echo; echo "List of all running processes: "; echo; ps ux; echo
}

killProc() {
	listProc
	echo; echo "Please enter the PID of the process to terminate: "
	read PID
	echo "PID: " $PID
	echo
	if [ -f /proc/$PID/exe ]; then #Looks for files in the /proc directory
		kill $PID
		echo -e $SUCCESS "The chosen process has been terminated."
	else
		echo -e $ERROR "The chosen process does not exist, or you are not its owner."
	fi
}

exitScript() {
	echo; echo "Exiting script session. Thankyou $USER."; echo; exit
}

while [ 1 ] #Loop runs continually until 'break' or 'exit'

do
	userOptions
	read USERCHOICE
	case $USERCHOICE in

	1) displayUserHome ;;

	2) listDir ;;

	3) findFile ;;

	4) editFile ;;

	5) copyFile ;;

	6) delFile ;;

	7) delDir ;;

	8) showDate ;;

	9) listProc ;;

	10) killProc ;;

	11) exitScript ;;

	*)

        echo -e $ERROR "$USERCHOICE is not a valid choice. Please select choice between 1 - 11 only";
	echo "To return to the menu, press Enter....... ";
	read enterKey ;;
	esac
done

