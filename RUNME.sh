#!/bin/sh

main_script_directory="$(dirname "$0")" #directory of THIS script

#child working directory definitions...
gui_dir="Sub_Applications/GUI_Frontend"

# Combine the main directory and the child directory to get the full path
full_gui_dir="$main_script_directory/$gui_dir"

#RUN GUI Dialog/Front End. That Python program will in turn load from and save to the configuration file and start the Director.sh program after that. The director program will read in all variables from the config.txt files and delegate all other subprograms accordingly.
x-terminal-emulator -e python3 -i $full_gui_dir/GUI_Frontend.py