# Python/Django Hello World project.


### Install necessary packages.

\
    `$ sudo apt-get update`
\
    `$ sudo apt-get install nginx python3-pip python3-dev ufw virtualenv postgresql postgresql-contrib libpq-dev`

### Install virtualenvwrapper & Config Shell Startup File & Create virtualenv folder.

- Create virtualevns folder

    `$ sudo mkdir /home/user_name/envs`

- Install virtualenvwrapper

    `$ sudo pip3 install virtualenvwrapper`

- Open .bashrc file

    `$ sudo vim ~/.bashrc`

    and paste below script.

    ```
    export WORKON_HOME="/home/user_name/envs"

    export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python3"

    source "/home/user_name/.local/bin/virtualenvwrapper.sh"
    ```

    We can get path of `python3` and `virtualenvwrapper.sh` with `which` 

    ex: `$ which virtualevnwrapper.sh` -> `/home/user_name/.local/bin/virtualenvwrapper.sh`

- Create virtualenv folder

    `$ mkvirtualenv helloworld`

### Config Postgresql
\
    `$ sudo -u postgres psql`

- Create database

    `postgres=# create database db_name;`

- Create user with encrypted password

    `postgres=# create user user_name with encrypted password 'user_pass';`

- Grant database to user

    `postgres=# grant all privileges on database db_name to user_name;`

### Install requirements to virtualenv.

- Navigate/to/project/root/path

    `$ cd ~/helloworld`

- Activate virtualenv

    `$ workon helloworld`

- Install requirements

    `(env) $ pip3 install -r requirements.txt`

### Migrate DB & Create super user & run server .
\
    `(env) $ python3 manage.py migrate`
\
    `(env) $ python3 manage.py createsuperuser`
\
    `(env) $ python3 manage.py runserver`
\
\
    It's engough for developing project in local.
    next steps are for deploy project to production server.

### Setting up gunicorn
\
    `(env) $ pip install gunicorn`
\
\
    if the development server is still running kill it change directory to your project folder and run the following command to run your site with gunicorn
\
\
    `(env) $ gunicorn --bind 0.0.0.0:8800 helloworld.wsgi:application`

\
    if everythin is ok, kill gunicorn and exit the virtual environment with the following command
\
    `(env) $ deactivate`
\
- Create gunicorn service file with below command

    `$ sudo vim /etc/systemd/system/gunicorn.service`

    and paste below script.
    
    ```
    [Unit]
        Description=gunicorn service
        After=network.target
    [Service]
        User=chris
        Group=www-data
        WorkingDirectory=/home/chris/webapp/helloworld/
        ExecStart=/home/chris/webapp/env/bin/gunicorn --access-logfile - --workers 3 --bind unix:/home/chris/webapp/helloworld/helloworld.sock helloworld.wsgi:application
    [Install]
        WantedBy=multi-user.target
    ```

    Change some variables to match your project’s location on your server.
- Start gunicorn

    `$ sudo systemctl enable gunicorn.service`

    `$ sudo systemctl start gunicorn.service`

    `$ sudo systemctl status gunicorn.service`

    if you changed something restart gunicorn with the following command

    `$ sudo systemctl daemon-reload`

    `$ sudo systemctl restart gunicorn`

### Configuring nginx
- Create a config file

    `$ sudo nano /etc/nginx/sites-available/helloworld`

    and paste below script.
    
    ```
    server {
       listen 80;
       server_name 127.0.0.1;
       location = /favicon.ico {access_log off;log_not_found off;}
       
       location = /static/ {
            root /home/chris/webapp/helloworld;
       }
       location = /media/ {
            root /home/chris/webapp/helloworld;
       }
       location = / {
            include proxy_params;
            proxy_pass http://unix:/home/chris/webapp/helloworld/helloworld.sock;
       }
    }
    ```

### Add a link of the nginx configuration & check the config.

\
    `$ sudo ln -s /etc/nginx/sites-available/helloworld /etc/nginx/sites-enabled`
\
\
    `$ sudo nginx -t`

\
    if everything worked fine restart nginx with the following command
\
    `$ sudo systemctl restart nginx`
\
\
The config files for nginx and gunicorn for this project are in `configs` folder.