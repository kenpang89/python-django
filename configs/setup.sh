#!/bin/bash
echo "Navigate to project root path ..."
cd ..
echo "Done. \n\n"

echo "Pull new changes ..."
git pull origin master >> ~/.ssh/id_rsa
echo "Done. \n\n"

echo "Active virtualenv ..."
workon helloworld
echo "Done. \n\n"

echo "Install requirements ..."
pip3 install -r requirements.txt
echo "Done. \n\n"

echo "Migrate database ..."
python3 manage.py migrate
echo "Done. \n\n"

echo "Update resources ..."
python3 manage.py collectstatic --noinput
echo "Done. \n\n"

echo "Restart gunicorn service ..."
visudo systemctl daemon-reload
visudo systemctl restart gunicorn
echo "Done. \n\n"

echo "Restart nginx service ..."
visudo systemctl restart nginx
echo "Done. \n\n"
