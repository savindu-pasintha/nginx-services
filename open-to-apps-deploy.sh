#!/bin/bash

# Navigate to your Next.js application directory
cd  ./app

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
