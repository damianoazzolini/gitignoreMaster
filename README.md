# Gitignore Master

Generate `.gitignore` files from command line, without needing to install further programs. 100% written in bash script.
You can specify the directory to output the file or append the output
in an already existing `.gitignore` file.

## Features

- No installation needed.
- 100% written in bash script.
- Support all `.gitignore` files.
- Support multiple input.
- Tested on Linux and Bash Ubuntu on Windws.

## Installation

Download source file from github with `git clone git@github.com:damianoazzolini/gitignoreMaster.git`

Add the program to the path to use it from everywhere.


## Commands Available

```
-h | --help, 	  show help;
-l | --list,	   show supported gitgnore files;
-d | --dir,	    create the .gitignore file into the specified directory,
        -d here / -d h to create the file in the current directory;
-i | --ignore,	 write on screen gitignore for selected language/tool;
```

## Usage Examples

Output on screen the `.gitignore` file for C programming language.
```
$ gitignoreMaster -i C
```
Show supported `.gitignore` files
```
$ gitignoreMaster -l
```
Create (or append) a `.gitignore` file in the current directory.
With `here` you specify the curent directory but you can choose a
different one.
```
$ gitignoreMaster -i C -d here
```
Create the `.gitignore` file with ignores for `C`, `Java` and `D` in `/temp/dir`
```
$ gitignoreMaster.sh -i c++ -i java -i d -d /temp/dir/
```
