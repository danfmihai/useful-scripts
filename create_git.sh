#!/bin/sh

#################################################################################  
#       Will create the current folder as a new repo into Github and push       #
#       all files into the new repo.                                            #
#       You need to add your token as an argument to be able to access          #
#       Github API.                                                             #
#       ex. sh create_git.sh <your token here>                                  #

# exit when any command fails
set -e

clear

reponame=$(basename $(pwd))
user_name="danfmihai"
git_token=$1

echo "Reponame is: ${reponame}"
echo "username: ${user_name}"
echo "Git token ${git_token}"

sleep 2

if [ $# -ne 0 ]; then

    if [ "$reponame" = "" ]; then
    read -p "Enter Github Repository Name: " reponame
    fi
    if [ $user_name = "" ]; then
    read -p "Enter Github Repository Name: " user_name
    fi
    
    echo "################################################################"
    echo "Your username/reponame are set as: ${user_name}/${reponame}.git"
    echo "################################################################"

    sleep 3

    # mkdir ./$reponame
    # cd $reponame
    #curl -u USERNAME https://api.github.com/user/repos -d "{\"name\":\"$reponame\"}"

    curl -i -H "Authorization: token $git_token" -d "{\"name\": \"$reponame\", \"auto_init\": \"true\" }" https://api.github.com/user/repos
    #curl -i -H "Authorization: token $git_token" -d "{\"name\": \"$reponame\", \"auto_init\": \"true\", \"private\": \"false\" }" https://api.github.com/user/repos
    git init
    echo "# ${reponame}" > README.md
    echo "create_git.sh" > .gitignore
    git add .
    git commit -m "initial commit --auto"
    git config pull.rebase false
    git pull origin main
    git remote add origin git@github.com/$user_name/$reponame.git
    git push -f --set-upstream origin main
    
else
    echo "Please add you token as an argument when you run the script!"
    echo "sh create_git.sh <yourtoken>"
fi    
