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

#!/bin/bash

# Clone Nginx configuration from GitHub
echo "Cloning Nginx configuration from GitHub..."
git clone https://github.com/savindu-pasintha/nginx-services.git /tmp/nginx-services

# Check if the clone was successful
if [ $? -ne 0 ]; then
    echo "Failed to clone Nginx configuration. Exiting."
    exit 1
fi

# Copy Nginx configuration to sites-available directory
echo "Copying Nginx configuration to /etc/nginx/sites-available/app1..."
sudo cp /tmp/nginx-services/nginx.conf /etc/nginx/sites-available/app1

# Create a symbolic link from sites-available to sites-enabled
echo "Creating symbolic link..."
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

# Restart Nginx to apply the new configuration
echo "Restarting Nginx..."
sudo systemctl restart nginx

# Check Nginx status to verify restart
sudo systemctl status nginx --no-pager

echo "Nginx configuration setup for app1 complete."

# Define variables and Navigate to your Next.js application directory
REPO_URL="https://github.com/username/my-project.git"
BRANCH_NAME="development"
CLONE_DIR="my-project"

# Clone the repository
echo "Cloning repository from $REPO_URL..."
git clone $REPO_URL $CLONE_DIR

# Navigate into the cloned repository directory
cd $CLONE_DIR

# Checkout the specific branch
echo "Checking out branch '$BRANCH_NAME'..."
git checkout $BRANCH_NAME

# Display current branch to verify
echo "Currently on branch: $(git branch --show-current)"

echo "Repository clone and branch checkout completed."

# Update npm dependencies
echo "Installing npm dependencies..."
# npm install

# Build your Next.js application (if needed)
echo "Building Next.js application..."
npm run build

# Install pm2 globally (if needed)
# npm install pm2 -g

# Start your Next.js application with pm2
echo "Starting Next.js application with pm2..."
pm2 start npm --name "app1" -- start

# Save current pm2 process list
pm2 save

# Monitor logs and save to file
echo "Monitoring logs..."
pm2 logs app1 > app1.log &

# Example of restarting the application
# echo "Restarting Next.js application..."
# pm2 restart nextjs-app

# Example of stopping the application
# echo "Stopping Next.js application..."
# pm2 stop nextjs-app

# Example of deleting the application from pm2
# echo "Deleting Next.js application from pm2..."
# pm2 delete nextjs-app
