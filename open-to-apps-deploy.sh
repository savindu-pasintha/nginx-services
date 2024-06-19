#!/bin/bash

echo "Downloading and Ubuntu packages..."
sudo apt-get update
sudo apt-get install curl nginx certbot python3-certbot-nginx

# sudo certbot --nginx -d your_domain

echo "Downloading and installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

echo "Sourcing ~/.bashrc to activate NVM in the current shell..."
source ~/.bashrc

echo "Checking if NVM is installed correctly..."
command -v nvm

echo "Installing the latest LTS version of Node.js..."
nvm install --lts

echo "Displaying Node.js version..."
echo "Node.js version:"
node --version

echo "Displaying npm version..."
echo "npm version:"
npm --version

echo "Listing installed Node.js versions..."
echo "Installed Node.js versions:"
nvm ls

echo "Cloning Nginx configuration from GitHub..."
git clone https://github.com/savindu-pasintha/nginx-services.git /tmp/nginx-services

if [ $? -ne 0 ]; then
    echo "Failed to clone Nginx configuration. Exiting."
    exit 1
fi

echo "Copying Nginx configuration to /etc/nginx/sites-available/app1..."
sudo cp /tmp/nginx-services/nginx.conf /etc/nginx/sites-available/app1

echo "Create a symbolic link from sites-available to sites-enabled..."
sudo ln -s /etc/nginx/sites-available/app1 /etc/nginx/sites-enabled/

# Test Nginx configuration
echo "Testing Nginx configuration..."
sudo nginx -t

# Check if the configuration test passed
if [ $? -ne 0 ]; then
    echo "Nginx configuration test failed. Rolling back changes."
    # Remove symbolic link if configuration test fails
    sudo rm /etc/nginx/sites-enabled/app1
    exit 1
fi

echo "Restart Nginx to apply the new configuration..."
sudo systemctl restart nginx

echo "Check Nginx status to verify restart.."
sudo systemctl status nginx --no-pager

echo "Nginx configuration setup for app1 complete."

echo "Define variables and Navigate to your Next.js application directory.."
REPO_URL="https://github.com/username/my-project.git"
BRANCH_NAME="development"
CLONE_DIR="my-project"

echo "Cloning PROJECT repository from $REPO_URL..."
git clone $REPO_URL $CLONE_DIR

echo "Navigate into the cloned repository directory.."
cd $CLONE_DIR

echo "Checkout the specific branch '$BRANCH_NAME'..."
git checkout $BRANCH_NAME

echo "Currently on branch: $(git branch --show-current)"
echo "Repository clone and branch checkout completed."

echo "Installing project npm dependencies..."
# npm install

echo "Building project application..."
npm run build

echo "Install pm2 globally (if needed)..."
# npm install pm2 -g

echo "Starting application with pm2..."
pm2 start npm --name "app1" -- start

echo "Save current pm2 process list..."
pm2 save
 
echo "Monitor logs and save to file..."
pm2 logs app1 > app1.log &

echo "pm2 apps list..."
pm2 list

# echo "Restarting  application..."
# pm2 restart app1

# echo "Stopping application..."
# pm2 stop app1

# echo "Deleting application from pm2..."
# pm2 delete app1
