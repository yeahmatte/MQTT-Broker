#!/bin/sh

git pull

pip3 install --upgrade -r ./requirements/python/requirements.txt

python3 install_tools/install.py
