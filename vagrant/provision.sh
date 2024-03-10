#!/bin/bash

# Update packages
apt-get update

# Install Python and pip
apt-get install -y python3 python3-pip

# Install virtualenv
pip3 install virtualenv

# Create a virtual environment in the vagrant user's home directory
if ! python3 -m venv /home/vagrant/venv; then
    echo "Virtual environment creation failed. Retrying..."
    python3 -m venv /home/vagrant/venv
fi

# Activate the virtual environment
source /home/vagrant/venv/bin/activate

# Navigate to the project source directory
cd /vagrant/src

# Install project dependencies
pip install -r requirements.txt

# Navigate to the Django project directory
cd calendar_api

# Run database migrations
python manage.py migrate