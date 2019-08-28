echo "Navigate to project root path ..."
cd ..
echo "Done. \n\n"

echo "Pull new changes ..."
git pull origin master
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
python3 manage.py collectstatic
echo "Done. \n\n"

echo "Restart gunicorn service ..."
sudo systemctl daemon-reload
sudo systemctl restart gunicorn
echo "Done. \n\n"

echo "Restart nginx service ..."
sudo systemctl restart nginx
echo "Done. \n\n"
