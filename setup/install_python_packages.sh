#/bin/bash
sudo apt-get install -y --no-install-recommends python-tk
sudo apt-get install -y --no-install-recommends python-setuptools
sudo apt-get install -y --no-install-recommends python3-setuptools
sudo pip install --upgrade pip
sudo pip3 install --upgrade pip
sudo /usr/bin/python2 -m pip install pylint -U
sudo /usr/bin/python3 -m pip install pylint -U
sudo /usr/bin/python2 -m pip install autopep8 -U 
sudo /usr/bin/python3 -m pip install autopep8 -U
sudo /usr/bin/python2 -m pip install autoflake -U
sudo /usr/bin/python3 -m pip install autoflake -U
