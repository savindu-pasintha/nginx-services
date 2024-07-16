# Run single service
sudo nano /etc/nginx/sites-available/myapp.conf
sudo rm /etc/nginx/sites-available/myapp.conf

`
server {
    listen 80;
    server_name 34.19.106.24;  # Replace with your server's public IP or domain name
 
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

sudo ln -s /etc/nginx/sites-available/myapp.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
sudo ufw allow 80/tcp
` 
# Run Multiple services configuration 
## if used plaed to use git clone the nginx service configurations
## from /etc/nginx/sites-available$ sudo git clone https://github.com/savindu-pasintha/nginx-services.git
`sudo ln -s /etc/nginx/sites-available/nginx-services/app.conf /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/nginx-services/service1.conf /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/nginx-services/service2.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
sudo ufw enable
sudo ufw allow 80/tcp
sudo ufw allow 3000/tcp
`

# CI/CD
`
#!/bin/bash

set -e

handle_error() {
    echo "Error occurred in script at line: $1"
    exit 1
}

trap 'handle_error $LINENO' ERR

echo "Updating and installing Ubuntu packages..."
sudo apt-get update
sudo apt-get install -y curl git nginx certbot python3-certbot-nginx

echo "Downloading and installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

echo "Sourcing ~/.bashrc to activate NVM in the current shell..."
source ~/.bashrc

echo "Checking if NVM is installed correctly..."
command -v nvm >/dev/null 2>&1 || { echo "NVM installation failed."; exit 1; }

echo "Installing the latest LTS version of Node.js..."
nvm install --lts

echo "Displaying Node.js version..."
node --version

echo "Displaying npm version..."
npm --version

echo "Listing installed Node.js versions..."
nvm ls

echo "Cloning Nginx configuration from GitHub..."
git clone https://github.com/savindu-pasintha/nginx-services.git /tmp/nginx-services || { echo "Failed to clone Nginx configuration."; exit 1; }

echo "Copying Nginx configuration to /etc/nginx/sites-available.."
sudo cp /tmp/nginx-services/app.conf /etc/nginx/sites-available/

echo "Creating a symbolic link from sites-available to sites-enabled..."
sudo ln -s /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/

echo "Testing Nginx configuration..."
sudo nginx -t || { echo "Nginx configuration test failed."; sudo rm /etc/nginx/sites-enabled/app1; exit 1; }

echo "Restarting Nginx to apply the new configuration..."
sudo systemctl restart nginx

echo "Checking Nginx status to verify restart..."
sudo systemctl status nginx --no-pager

echo "Enabling UFW firewall..."
echo "y" | sudo ufw enable

echo "Allowing HTTP traffic (port 80) through UFW..."
sudo ufw allow 80/tcp

echo "Allowing custom port (e.g., 3000) through UFW..."
sudo ufw allow 3000/tcp

echo "Nginx configuration setup for app1 complete."

REPO_URL="https://github.com/username/my-project.git"
BRANCH_NAME="development"
CLONE_DIR="my-project"

echo "Cloning project repository from $REPO_URL..."
git clone $REPO_URL $CLONE_DIR || { echo "Failed to clone project repository."; exit 1; }

echo "Navigating into the cloned repository directory..."
cd $CLONE_DIR

echo "Checking out the specific branch '$BRANCH_NAME'..."
git checkout $BRANCH_NAME || { echo "Failed to checkout branch '$BRANCH_NAME'."; exit 1; }

echo "Currently on branch: $(git branch --show-current)"
echo "Repository clone and branch checkout completed."

echo "Installing project npm dependencies..."
npm install

echo "Building project application..."
npm run build

echo "Installing pm2 globally (if needed)..."
npm install pm2 -g

echo "Starting application with pm2..."
pm2 start npm --name "app1" -- start

echo "Saving current pm2 process list..."
pm2 save

echo "Monitoring logs and saving to file..."
pm2 logs app1 > app1.log &

echo "Listing pm2 apps..."
pm2 list

echo "Restarting application..."
pm2 restart app1

echo "Stopping application..."
pm2 stop app1

echo "Deleting application from pm2..."
pm2 delete app1


`
