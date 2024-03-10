JWT authentication using Vagrant and VMware:

Django REST API with JWT Authentication using Vagrant and VMware
Prerequisites
Install Vagrant on your host machine.
Install VMware Workstation or VMware Fusion on your host machine.
Install the Vagrant VMware provider plugin by running the following command:

Copy code
vagrant plugin install vagrant-vmware-desktop
Project Setup
Create a new directory for your project and navigate to it in the terminal:

Copy code
mkdir calendar_project
cd calendar_project
Create a vagrant directory inside the project directory:

Copy code
mkdir vagrant
Navigate to the vagrant directory:

Copy code
cd vagrant
Initialize a new Vagrant project by running the following command:

Copy code
vagrant init
Open the generated Vagrantfile in a text editor and replace its contents with the following:
ruby


Copy code
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

  config.vm.provider "vmware_workstation" do |v|
    v.vmx["memsize"] = "2048"
    v.vmx["numvcpus"] = "2"
  end

  config.vm.synced_folder "src/", "/vagrant/src", type: "rsync",
    rsync__exclude: [".git/", "venv/", "*.pyc", "__pycache__/"]

  config.vm.network "forwarded_port", guest: 8000, host: 8088

  config.vm.provision "shell", path: "provision.sh"
end
Create a new file named provision.sh in the vagrant directory and add the following content:
bash


Copy code
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
pip install -r requirements.txt

# Navigate to the Django project directory
cd calendar_api

# Run database migrations
python manage.py migrate
Make the provision.sh file executable by running the following command:

Copy code
chmod +x provision.sh
Create a src directory inside the vagrant directory:

Copy code
mkdir src
Place your Django project files inside the src directory. Your project structure should look like this:

Copy code
calendar_project/
    └── vagrant/
        ├── src/
        │   ├── calendar_api/
        │   │   ├── config/
        │   │   │   ├── settings.py
        │   │   │   ├── urls.py
        │   │   │   ├── wsgi.py
        │   │   │   └── asgi.py
        │   │   ├── my_calendar_app/
        │   │   │   ├── migrations/
        │   │   │   ├── admin.py
        │   │   │   ├── apps.py
        │   │   │   ├── models.py
        │   │   │   ├── tests.py
        │   │   │   ├── views.py
        │   │   │   ├── urls.py
        │   │   │   └── __init__.py
        │   │   └── manage.py
        │   └── requirements.txt
        ├── .vagrant/
        ├── provision.sh
        └── Vagrantfile
Create a requirements.txt file inside the src directory and add the required packages:

Copy code
Django==3.2.4
djangorestframework==3.12.4
djangorestframework-jwt==1.11.0
Starting the Vagrant VM
Open a terminal or command prompt and navigate to the vagrant directory.

Start the Vagrant VM by running the following command:


Copy code
vagrant up --provider=vmware_workstation
This command will download the necessary box image, create a new VM, and provision it according to the configuration specified in the Vagrantfile and provision.sh script.

Once the VM is up and running, SSH into it using the following command:


Copy code
vagrant ssh
Running the Django Development Server
Inside the Vagrant VM, navigate to the Django project directory:

Copy code
cd /vagrant/src/calendar_api
Activate the virtual environment:

Copy code
source /home/vagrant/venv/bin/activate
Run the Django development server:

Copy code
python manage.py runserver 0.0.0.0:8000
Access your Django application by opening a web browser on your host machine and navigating to http://localhost:8088.
Developing the Django REST API
Inside the Vagrant VM, make sure you are in the Django project directory and the virtual environment is activated.
Create a new Django app for your API (if not already created):

Copy code
python manage.py startapp my_calendar_app
Implement your API views, serializers, and URLs in the my_calendar_app directory.
Update the project-level urls.py file to include the URLs for your API.
Configure JWT authentication in the project settings:
Add rest_framework and rest_framework_jwt to the INSTALLED_APPS list in settings.py.
Configure the authentication classes and permission classes in settings.py:
python


Copy code
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_jwt.authentication.JSONWebTokenAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
}
Create migrations for your app models:

Copy code
python manage.py makemigrations my_calendar_app
Apply the migrations to the database:

Copy code
python manage.py migrate
Test your API endpoints using tools like cURL, Postman, or the Django REST Framework browsable API.
Implement authentication and authorization logic in your API views using JWT.
Additional Commands
To suspend the Vagrant VM, run:

Copy code
vagrant suspend
To resume a suspended VM, run:

Copy code
vagrant resume
To shut down the VM, run:

Copy code
vagrant halt
To destroy the VM and remove all its resources, run:

Copy code
vagrant destroy
That's it! You now have a step-by-step guide on setting up a Django REST API project with JWT authentication using Vagrant and VMware. You can use this as a starting point for your project documentation and expand upon it based on your specific requirements and workflow.

Remember to keep your virtual environment activated while working on your project inside the Vagrant VM, and follow Django and Django REST Framework best practices while building your API.
