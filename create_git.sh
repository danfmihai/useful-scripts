#!/bin/sh
reponame=$(basename $(pwd))
username="danfmihai"
if [ "$reponame" = "" ]; then
read -p "Enter Github Repository Name: " reponame
fi
echo $reponame

# mkdir ./$reponame
# cd $reponame
#curl -u USERNAME https://api.github.com/user/repos -d "{\"name\":\"$reponame\"}"
curl -i -H "Authorization: token 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" -d "{\"name\": \"$reponame\", \"auto_init\": \"true\", \"private\": \"false\" }" https://api.github.com/user/repos
git init
echo>placeholder.txt
git add .
git commit -m "initial commit --auto"
git pull origin main
git remote add origin https://github.com/$username/$reponame.git
git push -f --set-upstream origin main

git pull $reponame main
git init
echo "# ${reponame}" > README.md
git add README.md
git commit -m "Starting Out"
git pull origin main
git remote add origin git@github.com:$username/$reponame.git
git push origin main 
