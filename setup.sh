#!/bin/bash

python3 -m venv ./.venv
source ./.venv/bin/activate
pip install -r requirements.txt

echo "Run \"source ./.venv/bin/activate\" to activate the vitrualenv"