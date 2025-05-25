# homebrew-app-availability
Only for macOS — checks if locally installed Apps have a possible counterpart in Homebrew

## What it does
Checks if locally installed Applications (in the `/Applications` folder) are **possibly** available in Homebrew.

Please be aware that this script uses a best effort strategy, and it will certainly exhibit false negatives and false positives.

## How it looks
![image](https://github.com/user-attachments/assets/3afeff83-e7e9-489a-b8f9-0f0e130cd33f)

## How to install

1. Download the script `homebrew-app-availability.sh`
2. Change the execution permissions with `chmod +x homebrew-app-availability.sh`
3. Run the script with `./homebrew-app-availability.sh [-r] [-s]`

Options:
* [-r] Rebuild the database (this may take a couple of minutes)
* [-s] Be shallow when (re)building the databse (just find applications in the `/Applications` folder, but not in its subfolders.)

## Credits
The idea for this script was launched in (subreddit s/macapp by u/amerpie)[https://www.reddit.com/r/macapps/comments/1ke6czi/how_to_check_all_your_apps_for_homebrew/].  I just perfected it a bit!  ;)
