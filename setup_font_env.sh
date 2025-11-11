#!/bin/bash
# Setup virtual environment for font conversion

echo "Setting up virtual environment for font conversion..."

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

# Activate and install dependencies
source venv/bin/activate
pip install -r requirements.txt

echo "Virtual environment ready!"
echo "To use font converter:"
echo "  source venv/bin/activate"
echo "  python3 convert_font.py"