# Run single service
sudo nano /etc/nginx/sites-available/myapp.conf
sudo rm /etc/nginx/sites-available/myapp.conf
`server {
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
