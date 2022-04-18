#!/bin/bash

clear 

if [ ! "$#" -ge 1 ]; then
    echo "You need to enter the <folder name to compress> and optional <path where to save>."
    echo "If no <path where to save> is given it will be saved in parent's folder of the <folder name to compress>"
    echo "ex.: ./compress-folder.sh /path/to/folder_name /path/where/to/save"
    echo "Please try again."
    exit
else
    
    SRC_FOLDER_PATH=$(dirname $1)
    FOLDER_TO_COMPRESS=$(basename $1)
    COMPRESSED_FILE_NAME="${FOLDER_TO_COMPRESS}_$(date +"%m_%d_%Y").tar.zst"
    if [ ! -z $2 ]; then
        PATH_TO_SAVE="$(dirname $2)/$(basename $2)"
    else
        PATH_TO_SAVE=$SRC_FOLDER_PATH
    fi       

    if [ ! -d $1 ] || [ ! -d $PATH_TO_SAVE ]; then
        echo "Path ${1} or ${PATH_TO_SAVE} doesn't exists! Will exit now."
        exit
    else
        echo "# - Checking folder ${1} size. Please wait..."
        folder_size=$(sudo du -hs $1 | awk {'print $1'})
        available_size=$(sudo df -h $PATH_TO_SAVE | awk {'print $4'} | tail -n 1) 
        fs=${folder_size:0:-1}
        av=${available_size:0:-1}
        echo "Folder size: " $folder_size
        echo "Available size: " $available_size
        
        if [ $fs -ge $av ]; then 
            echo "You won't have enough space to create the compressed folder!"
            exit
        else 

        echo "###########################################################"
        echo "#                   Compressing folder                    #"
        echo "###########################################################"
        echo "# - Folder to be compressed:                  ${FOLDER_TO_COMPRESS} - size: ${folder_size}"
        echo "# - Compressed file name to be created:       ${PATH_TO_SAVE}/${COMPRESSED_FILE_NAME}"
        echo "# - Please wait...it may take a long time if folder is large in size. Use CTRL-C to cancel."
        
        # number of cores for using multithred compression
        cores=$(grep -c ^processor /proc/cpuinfo)

        START="$(date +%s)"
        #tar acf $COMMPRESSED_FILE_NAME $SRC_FOLDER_PATH 
        cd $SRC_FOLDER_PATH
        sudo tar cf - $FOLDER_TO_COMPRESS | zstd -T$cores > "${PATH_TO_SAVE}/${COMPRESSED_FILE_NAME}"
        sleep 1
        DURATION=$[ $(date +%s) - ${START} ]
        after_size=$(ls -hl ${COMMPRESSED_FILE_NAME} | awk {'print $5'})

        echo "###########################################################"
        echo "# - Folder to compress:                   ${FOLDER_TO_COMPRESS}    "
        echo "# - Before compression, folder size is:   ${folder_size}           "
        echo "# - After compression, file size is:      ${after_size}                  "
        echo "# - Duration:                             ${DURATION}s              "
        echo "###########################################################"  
        fi
    fi    
fi