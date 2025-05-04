#!/bin/bash
#
# Copyright © João Lourenço <joao.lourenco@fct.unl.pt>
#
# The idea for this script was launched in subreddit s/macapp by u/amerpie
# [https://www.reddit.com/r/macapps/comments/1ke6czi/how_to_check_all_your_apps_for_homebrew/].
# I just perfected it a bit!  ;)

APPS=/tmp/apps_local.txt
BREW_ALL=/tmp/brew_all.txt
BREW_LOC=/tmp/brew_local.txt

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CURR=$(echo '\033[0m')

LAST_FILES=$([ -f $BREW_LOC ] && stat -c "%y" $BREW_LOC | cut -d " " -f 1 || echo 0)
NOW=$(date +%Y-%m-%d)

# Parse options
reload=""
shallow=""
while getopts "rs" opt; do
  case "$opt" in
    r)
      reload=true
      ;;
    s)
      shallow="-maxdepth 1"
      ;;
    \?|h)
      echo "Usage: $0 [-r]"
      exit 1
      ;;
  esac
done

if [ "$LAST_FILES" != "$NOW" -o -n "$reload" ]; then
  # List all applications in /Applications and ~/Applications 
  echo "Fetching all Apps and all Brew formulae and casks"
  echo "This may take some time"
  ( find /Applications $shallow -type d -name "*.app" > $APPS ) &
  ( brew search /./ > $BREW_ALL ) &
  ( brew list > $BREW_LOC ) &
  wait
else
  echo "Using existing databases. Use option '-r' to force regeneration."
fi

echo "TOTAL BREW = $(wc -l $BREW_ALL)"
echo "BREW LOCAL = $(wc -l $BREW_LOC)"
echo "LOCAL APPS = $(wc -l $APPS)"

cat $APPS | while read -r app_path; do 
	app_name=$(basename "$app_path" .app)
  # echo "Checking: $app_name"
	# Sanitize the app name for Homebrew search (replace spaces with hyphens, etc.) 
	search_term=$(echo "$app_name" | sed -e 's/ /-/g' -e 's/\./-/g' -e 's/@.*//') # Basic sanitization, might need more
	# Search Homebrew
  PACKAGES=$(grep -i "$search_term" $BREW_ALL)
  if [ -n "$PACKAGES" ]; then
    # Print the Application pathname
    echo "--------------------------------------------"
    echo "$app_path"
    echo "--------------------------------------------"
    # Find the longest of the matches (if any)
    longest=0
    for word in $PACKAGES; do
      if (( ${#word} > longest )); then
        longest=${#word}
      fi 
    done
    LONG=$(( $longest + 1))
    # For each match, print if intalled or not installed
    for i in $PACKAGES; do
      EXISTS=$(grep $i $BREW_LOC)
      if [ -n "$EXISTS" ]; then
        printf "%-${LONG}s %b\n" "$i" "${GREEN}Installed${CURR}"
      else
        printf "%-${LONG}s %b\n" "$i" "${RED}Not Installed${CURR}"
      fi
    done
  fi
done
