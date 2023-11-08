#!/bin/sh

main_script_directory="$(dirname "$0")" #directory of THIS script

#child working directory definitions...
main_input_dir="Master_Input_Folder/"
main_output_dir="Master_Output_Folder/"
autocropper_input_dir="Sub_Applications/Autocropper/Image_Input_Directory/"
autocropper_output_dir="Sub_Applications/Autocropper/Image_Output_Directory/"
titler_input_dir="Sub_Applications/Google_Lens_Batcher_METADATA_DEPENDENT/Image_Input_Directory/"
titler_output_dir="Sub_Applications/Google_Lens_Batcher_METADATA_DEPENDENT/Image_Output_Directory/"
consolidator_input_dir="Sub_Applications/Listing_Consolidator/Input_Directory/"
consolidator_output_dir="Sub_Applications/Listing_Consolidator/Output_Directory/"
extractor_input_dir="Sub_Applications/Listing_Metadata_Extractor/Image_Input_Directory/"
extractor_output_dir="Sub_Applications/Listing_Metadata_Extractor/Image_Output_Directory/"
bgremover_input_dir="Sub_Applications/rembg-main/Image_Input_Directory/"
bgremover_output_dir="Sub_Applications/rembg-main/Image_Output_Directory/"
coloradjuster_input_dir="Sub_Applications/Color_Adjuster/Image_Input_Directory/"
coloradjuster_output_dir="Sub_Applications/Color_Adjuster/Image_Output_Directory/"
coloradjuster_recursive_dir="Sub_Applications/Color_Adjuster/Recursive_Image_Save_Temp_Dir/"
consolidator_temp_dir="Sub_Applications/Listing_Consolidator/tempCache/"

config_file="Config.txt" #configuration file definition...
file_history="FileHistory.txt" #file history tracking file...

# Combine the main directory and the child directory to get the full path
full_main_input_dir="$main_script_directory/$main_input_dir"
full_main_output_dir="$main_script_directory/$main_output_dir"
full_autocropper_input_dir="$main_script_directory/$autocropper_input_dir"
full_autocropper_output_dir="$main_script_directory/$autocropper_output_dir"
full_titler_input_dir="$main_script_directory/$titler_input_dir"
full_titler_output_dir="$main_script_directory/$titler_output_dir"
full_consolidator_input_dir="$main_script_directory/$consolidator_input_dir"
full_consolidator_output_dir="$main_script_directory/$consolidator_output_dir"
full_extractor_input_dir="$main_script_directory/$extractor_input_dir"
full_extractor_output_dir="$main_script_directory/$extractor_output_dir"
full_bgremover_input_dir="$main_script_directory/$bgremover_input_dir"
full_bgremover_output_dir="$main_script_directory/$bgremover_output_dir"
full_coloradjuster_input_dir="$main_script_directory/$coloradjuster_input_dir"
full_coloradjuster_output_dir="$main_script_directory/$coloradjuster_output_dir"
full_coloradjuster_recursive_dir="$main_script_directory/$coloradjuster_recursive_dir"
full_consolidator_temp_dir="$main_script_directory/$consolidator_temp_dir"

#removing any temporary files AND SUBFOLDERS (***PATCHED***) in each relevant child directory from any previous instances of this program running... (PRE Batch Run)
find "$full_main_output_dir" -mindepth 1 -delete
find "$full_autocropper_input_dir" -mindepth 1 -delete
find "$full_autocropper_output_dir" -mindepth 1 -delete
find "$full_titler_input_dir" -mindepth 1 -delete
find "$full_titler_output_dir" -mindepth 1 -delete
find "$full_consolidator_input_dir" -mindepth 1 -delete
find "$full_consolidator_output_dir" -mindepth 1 -delete
find "$full_extractor_input_dir" -mindepth 1 -delete
find "$full_extractor_output_dir" -mindepth 1 -delete
find "$full_bgremover_input_dir" -mindepth 1 -delete
find "$full_bgremover_output_dir" -mindepth 1 -delete
find "$full_coloradjuster_input_dir" -mindepth 1 -delete
find "$full_coloradjuster_output_dir" -mindepth 1 -delete
find "$full_coloradjuster_recursive_dir" -mindepth 1 -delete
find "$full_consolidator_temp_dir" -mindepth 1 -delete

#Clearing out configuration file...
truncate -s 0 $config_file

#Clearing out file history text file...
truncate -s 0 $file_history

#Generating 50 blank new lines in configuration file to serve as future placeholders for each setting line.
printf '\n%.0s' `seq 1 50` >> "$config_file"

#Generating a few new lines in history file to serve as future placeholders for each setting line.
printf '\n%.0s' `seq 1 1` >> "$file_history"

echo "Forced program cleanup successful. Enter 'exit(),' CTRL+D, or force close GUI window to exit. This program will automatically close in 60 seconds. Please be sure to view logs in terminal if needed."
read -p " " </dev/tty
sleep 60
