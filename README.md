# useful-scripts

1. `bootstrap.sh` 
- used for Centos or Ubuntu to install packages that are set in the PKG variable.

2. `create_git.sh`
- creates a Github repo with your current folder as the repo name and pushes all the files to the newly created repo. To use it you need to create a token in your Github account under Developer Settings and use the token as an argument when you run the script as follows:

```
sh create_git.sh <your token here>
```