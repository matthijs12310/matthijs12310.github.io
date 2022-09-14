#!/bin/bash

echo UberSpace MC Server script
echo
echo MAKE SURE TO RUN SCREEN BEFORE RUNNING THIS OTHERWISE YOU WIL STOP YOUR SERVER WHEN EXITING THE CMD
echo
PS3='Please enter your choice: '
options=("Start Server" "Install Server" "Upload" "Download" "Exit")
select opt in "${options[@]}"
do
    case $opt in
        "Start Server")
	    cd mc
	    ./java/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui
	    break
            ;;
        "Install Server")
            FOLDER=~/mc
	    if [ -d "$FOLDER" ]; then
		echo You have already installed the server. Run the script again to start it.
	        break
	    fi
	    mkdir mc
	    cd mc 
	    wget https://download.oracle.com/java/18/latest/jdk-18_linux-x64_bin.tar.gz
	    tar -xzf jdk-18_linux-x64_bin.tar.gz
	    mv jdk-18.0.2.1/ java/
	    rm jdk-18_linux-x64_bin.tar.gz
	    wget https://api.papermc.io/v2/projects/paper/versions/1.19.2/builds/135/downloads/paper-1.19.2-135.jar
	    mv paper-1.19.2-135.jar server.jar
	    echo eula=true > eula.txt
            uberspace port add
	    PORT=$(uberspace port list)
	    echo "server-port=$PORT" > server.properties 
            ;;
        "Upload")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Download")
            echo "You chose 4"
            ;;
	"Exit")
	    break
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done
