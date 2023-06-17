# Deploy wordpress using docker compose and shell script


This script allows you to manage your wordpress site running in docker containers. It provides functionality to enable, disable, and delete the site. Using this script it detects if docker is installed or not if not it will install also same with docker compose, later it will fetch require images and start configuring it.

## Prerequisites

bash shell cmd.

## Usage

1. Clone this repository or copy the script to your local machine.

2. Make the script executable:
   ```bash
     chmod +x bash.sh
     sudo ./bash.sh <website_name> <enable or disable or delete>
   

Using above script you can install docker if not present and launch wordpress website.
