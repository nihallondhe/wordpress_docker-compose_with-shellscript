#!/bin/bash
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    # Install Docker
    sudo apt update
    sudo apt install -y docker.io
    sudo usermod -aG docker $USER
    echo "Docker has been installed."
else
    echo "Docker is already installed."
fi

# Checking docker dompose is installed or not 

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose has been installed."
else
    echo "Docker Compose is already installed."

fi


# Checking website name is in form of command line argument is provided or not
if [[ $# -lt 2 ]]; then
    echo "Usage: $0  <website_name> <subcommand>"
    echo "Available subcommands: enable, disable, delete"
    exit 1
fi

# Assign the provided website name to a variable
WEBSITE_NAME="$1"
SUBCOMMAND="$2"


# Start the docker containers using docker compose and configure
function enable_site() {
    
    mkdir wp-content

    docker-compose up -d
  
    echo "wait for container up"
    sleep 10
#--------------------------------------------------------------------------------------Docker exec process
    docker exec -it "$(docker ps -qf "name=wordpress")" bash -c 'curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar '

docker exec -it "$(docker ps -qf "name=wordpress")" bash -c  'php wp-cli.phar --info'

docker exec -it "$(docker ps -qf "name=wordpress")" bash -c 'chmod +x wp-cli.phar'

docker exec -it "$(docker ps -qf "name=wordpress")" bash -c 'mv wp-cli.phar /usr/local/bin/wp'

docker exec -it "$(docker ps -qf "name=wordpress")" bash -c 'wp --allow-root core install --url=http://localhost:8000 --title="$WEBSITE_NAME" --admin_user=admin --admin_password=password --admin_email=admin@example.com'


docker exec -it "$(docker ps -qf "name=wordpress")" bash -c 'wp --allow-root option update blogdescription "Welcome to $WEBSITE_NAME!" '


#docker exec -it "$(docker ps -qf "name=wordpress")" bash -c 'wp --allow-root plugin uninstall hello'


#---------------------------------------------------------------------------------
 echo "Configure host"
 echo "127.0.0.1 $WEBSITE_NAME" | sudo tee -a /etc/hosts


 echo "WordPress with the latest version has been successfully created!"
 echo "You can access your website at http://$WEBSITE_NAME:8000"


}

# Function to disable the site (stop the containers)
function disable_site() {
   
    docker-compose down

    echo "Site has been disabled."
}

# Function to delete the container and website content
function delete_site() {
    
    docker-compose down

    rm -rf db_data wp-content

    echo "Site has been deleted."
}


case "$SUBCOMMAND" in
    "enable")
        enable_site
        ;;
    "disable")
        disable_site
        ;;
    "delete")
        delete_site
        ;;
    *)
        echo "Invalid subcommand. Available subcommands: enable, disable, delete."
        exit 1
        ;;
esac
