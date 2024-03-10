#!/bin/bash

# Update packages
apt-get update

# Install Python and pip
apt-get install -y python3 python3-pip

# Install python3-venv package
apt-get install -y python3-venv

# Install virtualenv
pip3 install virtualenv

# Create a virtual environment in the vagrant user's home directory
python3 -m venv /home/vagrant/venv

# Activate the virtual environment
source /home/vagrant/venv/bin/activate

# Navigate to the project source directory
cd /vagrant/src

# Install project dependencies
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "requirements.txt not found. Skipping package installation."
fi

# Navigate to the Django project directory
if [ -d "calendar_api" ]; then
    cd calendar_api
    # Run database migrations
    python manage.py migrate
else
    echo "calendar_api directory not found. Skipping database migration."
fi