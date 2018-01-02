#!/bin/bash

wget=/usr/bin/wget
unzip=/usr/bin/unzip
cut=/usr/bin/cut

rm=/bin/rm
ls=/bin/ls
mv=/bin/mv
grep=/bin/grep
cat=/bin/cat
pwd=/bin/pwd
sed=/bin/sed

directory=/tmp #save /home/gitignoreMaster/

URLGITIGNORE="https://github.com/github/gitignore/archive/master.zip"
WGETOPTIONS="-q -P $directory" #-q turn off output, -P specify directory
UNZIPOPTIONS="-qq -d $directory" #-qq superquiet
UNZIPFILE="$directory/master.zip"
FILENAME="$directory/gitignore-master"
REMOVEOPTIONS="-r -d" #remove directory and everything inside
CUTOPTIONS="-d . -f 1"
GREPOPTIONS="-i -w" #-i ignore case, -w match exact case
NAME="gitignoreMaster"

############################################supportare più gitignore consecutivi

#print help
function printHelp {
	echo "
	WELCOME TO GITIGNORE MASTER

	USAGE EXAMPLE: $NAME -i java [-d dir]

	COMMAND LIST:

		-h | --help, 	show this help;
		-l | --list,	show supported gitgnore files;
		-d | --dir,	create the .gitignore file into the specified directory
				-d here creates the file in the current directory;
		-i | --ignore,	write on screen gitignore for selected language/tool;
	"
	exit
}

#print ignore
function printIgnore {
	read res < <($ls $FILENAME | $cut $CUTOPTIONS | $grep $GREPOPTIONS "$1")
	echo "# $res"
	if [ ! -z "$res" ]; then
		read file1 < <(echo "${res^}")
		gitign=.gitignore
		file=$file1$gitign
		$cat $FILENAME/"$file"
	else
		echo "#Gitignore not available for $1"
	fi
}

#show available gitignore
function showAvailableGitignore {
	#ls | cut -d '.' -f 1
	echo "GITIGNORES AVAILABLE"
	$ls $FILENAME | $cut "$CUTOPTIONS"
}

#move all files up a dir
function moveUp {
	$mv $FILENAME/Global/* ../ #move all elemen on parent folder
	$rm $REMOVEOPTIONS Global
}

#create .gitignore file
function createGitignore {
	#$1 path, $2 ignore
	ign=.gitignore
	if [ "$1" == "here" ] || [ "$1" == "h" ]; then
		read currentDir < <($pwd | $sed 's/ /\\ /g')
		place=$currentDir/$ign
	else
		place=$1/$ign
	fi

	if [ ! -f "$place" ]; then
		echo "Created .gitignore file"
	fi
	echo "Insert gitignore for $2"
	printIgnore "$2" >> "$place"
}

#unzip file
function unzipfile {
	if [[ ! -f "$UNZIPFILE" ]]; then
		echo "Problem, file not found"
	else
		$unzip ${UNZIPOPTIONS} ${UNZIPFILE}
	fi
}

#diwnload file
function downloadFile {
	#echo "Check for updates"
	if [[ ! -d "$FILENAME" ]]; then
		#not downloaded .zip
		if [ ! -d "$UNZIPFILE" ]; then
			#echo "Updating library"
			$wget ${WGETOPTIONS} ${URLGITIGNORE}
			#check if is really downloaded
			if [ ! -f "$UNZIPFILE" ]; then
				echo "Error downloading file"
				exit -1
			else
				unzipfile
				rm $UNZIPFILE
				moveUp
			fi
		#downloaded but not extracted
		else
			unzipfile
			rm $UNZIPFILE
			moveUp
		fi
	fi
	#echo "Library updated"
}

#check if programs are installed
function checkProgramInstalled {
	if [ ! -x "$1" ]; then
		echo "$1 not installed"
		echo "Please install $1 with: apt install $1"
		exit 1
	fi
}

############################################################################à###
#execution

#check if rograms exists
checkProgramInstalled $wget
checkProgramInstalled $unzip
checkProgramInstalled $cut

#downlad files
downloadFile

#check if 0 parameters
if [ "$#" -eq 0 ]; then
	printHelp
	exit
fi

create=
path=

declare -a ARRAY
i=0

#read parameters
while [ "$1" != "" ]; do
	case $1 in
		-l | --list)
			showAvailableGitignore
			exit;;
		-h | --help)
			printHelp
			exit;;
		-i | --ignore)
			shift
			#ignore=$1
			ARRAY[$i]=$1
			i=$(( $i + 1 ));;
		-d | --dir)
			shift
			create="yes"
			path=$1;;
		*)
			echo "$1 unknown parameter"
			printHelp
			exit;;
	esac
	shift
done

for (( j = 0; j < i; j++ )); do
	if [ ${#ARRAY[@]} -ne 0 ]; then
		if [ ! -z "$create" ] && [ ! -z "$path" ]; then
			createGitignore $path ${ARRAY[j]}
		else
			printIgnore ${ARRAY[j]}
		fi
	fi
done
