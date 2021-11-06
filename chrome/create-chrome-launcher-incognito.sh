#!/bin/bash


PROFILE_NAME=$1

cp -r "/Applications/Google Chrome.app" "/Applications/Google Chrome ${PROFILE_NAME}.app"


mkdir -p "/Applications/Chrome ${PROFILE_NAME}.app/Contents/MacOS"

F="/Applications/Chrome ${PROFILE_NAME}.app/Contents/MacOS/Chrome ${PROFILE_NAME}"
cat > "$F" <<\EOF
#!/bin/bash

#
# Google Chrome for Mac with additional profile.
#

# Name your profile:
EOF

echo "PROFILE_NAME='$PROFILE_NAME'" >> "$F"

cat >> "$F" <<\EOF
# Store the profile here:
PROFILE_DIR="/Users/$USER/Library/Application Support/Google/Chrome/${PROFILE_NAME} Profile"

# Find the Google Chrome binary:
CHROME_BIN="/Applications/Google Chrome ${PROFILE_NAME}.app/Contents/MacOS/Google Chrome"
if [[ ! -e "$CHROME_BIN" ]]; then
  echo "ERROR: Can not find Google Chrome.  Exiting."
  exit -1
fi

# Start me up!
exec "$CHROME_BIN" --enable-udd-profiles --user-data-dir="$PROFILE_DIR" --incognito
EOF

sudo chmod +x "$F"
