#!/bin/bash
sudo service ssh start
sudo service postgresql start

# Switch to the vscode user and start a login shell
exec su - vscode
