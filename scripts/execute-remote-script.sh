
#!/bin/bash

# NOTE:
# assumes the script is run on repo root

# check if the SCRIPT_NAME argument is provided
if [ -z "$1" ]; then
  echo "Error: No SCRIPT_NAME provided."
  echo "Usage: $0 delete-version.sh"
  exit 1
fi

SCRIPT_BASE_URL="https://raw.githubusercontent.com/dominicstop/DGSwiftUtilities/refs/heads/main/scripts"

# E.g. delete-version.sh
SCRIPT_NAME="$1"

SCRIPT_URL="${SCRIPT_BASE_URL}/${SCRIPT_NAME}"
TEMP_SCRIPT_NAME="temp-$SCRIPT_NAME"
TEMP_SCRIPT_PATH="/tmp/$TEMP_SCRIPT_NAME"

echo "Script Repo URL: $SCRIPT_BASE_URL"
echo "Script: $SCRIPT_NAME"

echo "Fetching script..."
curl -s $SCRIPT_URL -o $TEMP_SCRIPT_PATH
chmod +x $TEMP_SCRIPT_PATH

echo "Executing script: $TEMP_SCRIPT_PATH"
$TEMP_SCRIPT_PATH ; 

echo "Cleaning up..."
rm -f $TEMP_SCRIPT_PATH