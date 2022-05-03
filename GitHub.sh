# Inputs
user="<your_username>"
## Do not replace quotes with double quotes
encryptedPassword='<encrypted_github_token>'

# Default configuration
commitMessage="v1.0"
branch="master"

#########
pu="push"

#########

if [ $# = 0 ]
then
	echo error, no input args !
	exit 2;
fi

if [ $1 = "-h" ] || [ $1 = "--help" ] || [ $1 = "help" ]
then
	cat << EOF
usage: Git [-v| --version] [-h | --help]
	   [option] [msg] [files]
These are common Git commands used in various situations:
clone [name]
	   Clone a repository into a newly created directory.
create <-p> [name]
	   Create new repository. Use -p option to create private repository
delete [name]
	   Delete repository.
-f
	   Disable checks. It can cause the remote repository to lose commits, use it with care.
-h | --help | help
	   Print a list of the most commonly used commands.
-m [msg]
	   Use the given <msg> as the commit message.
-M [name]
	   Moves/renames a branch.
-n
	   Pull changes from remote repository.
-r [name]
	   Indicate Git Repository.
-t [name]
	   Give tag to a specified commit.
-v | --version
	   Print the Git suite version that the git program came from.
EOF
	exit 0
elif [ $1 = "-v" ] || [ $1 = "--version" ]
then
	echo Git version 2.0
	exit 0
elif [ $1 = "clone" ]
then
	git clone https://$user:$(echo $encryptedPassword | openssl aes-256-cbc -pbkdf2 -d -a 2> /dev/null )@github.com/$user/$2.git
	exit 0
elif [ $1 = "create" ]
then
	if [ $2 = "-p" ]
	then
		curl -X POST -u $user:$(echo $encryptedPassword | openssl aes-256-cbc -pbkdf2 -d -a 2> /dev/null ) https://api.github.com/user/repos -d "{\"name\":\"$3\", \"private\":\"true\"}"
	else
		curl -X POST -u $user:$(echo $encryptedPassword | openssl aes-256-cbc -pbkdf2 -d -a 2> /dev/null ) https://api.github.com/user/repos -d "{\"name\":\"$2\"}"
	fi
	exit 0
elif [ $1 = "delete" ]
then
	curl -X DELETE -u $user:$(echo $encryptedPassword | openssl aes-256-cbc -pbkdf2 -d -a 2> /dev/null ) https://api.github.com/repos/$user/$2
	exit 0
fi
while [ $# != 0 ]
	do
	case $1 in
		-m)
		shift
		commitMessage=$1
		;;

		-M)
		shift
		branch=$1
		;;
		
		-r)
		shift
		repository=$1
		;;
		
		-p)
		pu="pull"
		;;
		
		-f)
		forced="-f"
		;;
		
		-t)
		shift
		tag=$1
		tagFlag="--tags"
		;;
		
		-*)
		echo Ignore $1 option
		;;
		
		*)
		files=$files\ $1
		;;
	esac
	shift
done
if [ -z $repository ]
then
	echo Repository name is not valid, use -r followed by repository name
	exit -1
fi
if ! [[ -d ".git" ]]
then
	git init
	if [ -z $files ]
	then
		files="."
	fi
	git add $files
else
	test -z $files || git add $files
fi
git commit -m $commitMessage
git branch -M $branch
git remote add origin https://$user:$(echo $encryptedPassword | openssl aes-256-cbc -pbkdf2 -d -a 2> /dev/null )@github.com/$user/$repository.git
test -z $tag || git tag -a $tag -m $commitMessage
#git checkout $branch
git $pu $forced --set-upstream origin $branch $tagFlag
exit 0
