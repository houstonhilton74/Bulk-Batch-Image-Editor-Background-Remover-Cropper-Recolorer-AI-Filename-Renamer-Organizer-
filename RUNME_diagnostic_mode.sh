#!/bin/sh

main_script_directory="$(dirname "$0")" #directory of THIS script
apiDecision="y"
apiType="ebay"
inBetweenDecision="n"
imageColoringDecision="n"
backgroundRemovalDecision="y"
croppingDecision="y"
metadataDecision="y"
inputHolder="NULL"
coloringScript="NULL"
config_file="Config.txt"
temp_file="temp_file.txt"
file_history="FileHistory.txt"

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

###USER QUESTIONS PROMPT SECTION###

echo "(y or n) Would you like to adjust the coloring for your image lot? Refer to the README file for image color scripting usage." 
read imageColoringDecision

if [ "$imageColoringDecision" = "y" ]; then #code that allows you to enter in a new image coloring script and save it to the config.txt file each time. This segment is intended for the diagnostic version of the program only. It should not be used in the GUI version.
	echo "Enter image coloring operation(s) script: " 
	read coloringScript
	sed -i "1s/.*/coloringOperationScript=$coloringScript/" "$config_file"
else
	sed -i "1s/.*/coloringOperationScript=NULL/" "$config_file" #filling in placeholder if the coloring option is not elected...
fi

echo "(y or n) Would you like to use either Ebay's or Google Vision's API to try to automatically rename the names of your images for better organization purposes? Otherwise, they will default to their original supplied filename(s)." 
read apiDecision

if [ "$apiDecision" = "y" ]; then
	sed -i "2s/.*/useAPIRenamer=YES/" "$config_file"
	echo "Would you like to use Ebay's SearchByImage API or Google's Vision API for automatically renaming your image file batch today? The default is Ebay's. Type 'ebay' or 'google' accordingly: " 
	read apiType
	
	if [ "$apiType" = "ebay" ]; then
		sed -i "3s/.*/apiType=EBAY/" "$config_file"
		echo "When choosing the Ebay API, Ebay requires a valid O'Auth User Access Token configured for the Ebay production environment that needs to be refreshed every few hours. To accomplish this, be sure to copy over the key text and replace whatever's in the ebayUserAccessToken.txt text file located in the main program directory after you have successfully setup an Ebay Developer account. Hit enter when you have completed this."
		echo
		read inputHolder
	else
		sed -i "3s/.*/apiType=GOOGLE/" "$config_file"
	fi
else
	sed -i "2s/.*/useAPIRenamer=NO/" "$config_file"
	sed -i "3s/.*/apiType=NULL/" "$config_file"
fi


echo "(y or n) Would you like to check for any in-between images that may be present for each inputted image? It's useful if you have, for example, pictures of your listings from odd angles that cannot be fed into the AI input folder directly. Be sure to include the full image lot in the appropriate folder to ensure that things work correctly if yes." 
read inBetweenDecision
if [ "$inBetweenDecision" = "y" ]; then
	sed -i "4s/.*/inBetweenImages=YES/" "$config_file"
else
	sed -i "4s/.*/inBetweenImages=NO/" "$config_file"
fi

echo "(y or n) Would you like to try to automatically remove the backgrounds around your image batch, leaving white space in the gap around the main subject in each? Please note that not doing this will cause the batch image cropper to not perform as well if background removal is disabled." 
read backgroundRemovalDecision
if [ "$backgroundRemovalDecision" = "y" ]; then
	sed -i "5s/.*/backgroundRemoval=YES/" "$config_file"
else
	sed -i "5s/.*/backgroundRemoval=NO/" "$config_file"
fi

echo "(y or n) Would you like to try to automatically crop your image batch?" 
read croppingDecision
if [ "$croppingDecision" = "y" ]; then
	sed -i "6s/.*/cropImages=YES/" "$config_file"
else
	sed -i "6s/.*/cropImages=NO/" "$config_file"
fi
echo "(y or n) Would you like to try to generate AI metadata text files using Google Vision from your image batch? Please see usage in README.txt file regarding it's usage. Please also note that this feature is currently very experimental." 
read metadataDecision
if [ "$metadataDecision" = "y" ]; then
	sed -i "7s/.*/generateMetadata=YES/" "$config_file"
else
	sed -i "7s/.*/generateMetadata=NO/" "$config_file"
fi

###USER QUESTIONS PROMPT SECTION END###

if [ "$imageColoringDecision" = "y" ]; then #Bulk image coloring call...
	cp -r "$full_main_input_dir"* "$full_coloradjuster_input_dir" #copying all files from main input directory to Color Adjuster's Input Directory if the image coloring operations are used...
	echo "Starting bulk image coloring program based on user-defined coloring operations script..."
	echo
	x-terminal-emulator -e python3 -i $main_script_directory/Sub_Applications/Color_Adjuster/source_script.py
	echo "Color adjustment image processing completed."
	echo
	cp -r "$full_coloradjuster_output_dir"* "$full_bgremover_input_dir" #copy images from color adjuster's output directory to the background remover's input directory...

	sleep 3
else
	#copying all files from main input directory to Background Remover's Input Directory if the image coloring operations are not used...
	cp -r "$full_main_input_dir"* "$full_bgremover_input_dir"
fi

echo

#Image background removal direct call at this point.
if [ "$backgroundRemovalDecision" = "y" ]; then
	echo "Starting batch background remover AI..."
	echo
	sleep 3
	x-terminal-emulator -e rembg p --bgcolor=255 255 255 255 -ppm $full_bgremover_input_dir $full_bgremover_output_dir
	echo "Batch image background removal complete."
	echo
	sleep 3
	echo "Generating history data for background removal PROGRAM..."
	echo
	x-terminal-emulator -e python3 -i $main_script_directory/Sub_Applications/rembg-main/history_generator.py
	echo "Background removal history data processing completed."
	sleep 3
else
	#If user doesn't want image background removal, it will instead copy all files from background remover's input directory to its output directory, but the program itself will not process the files at any time...
	cp -r "$full_bgremover_input_dir"* "$full_bgremover_output_dir" 
fi
	
cp -r "$full_main_input_dir"* "$full_extractor_input_dir"

#Metadata generation call...
#Run metadata extraction from Main Input images if and only if the user requests so.
if [ "$metadataDecision" = "y" ]; then
	echo "Starting metadata generation..."
	echo
	sleep 3
	x-terminal-emulator -e python3 -i $main_script_directory/Sub_Applications/Listing_Metadata_Extractor/source_script.py
	echo "Meta generation completed."
	echo
	sleep 3

fi

cp -r "$full_bgremover_output_dir"* "$full_titler_input_dir"

#Image file renamer call... It only runs based on user decision. Otherwise, the files copied into its input folder will be copied over to its output folder untouched...
if [ "$apiDecision" = "y" ]; then
	echo "Starting AI Image file renamer..."
	echo
	sleep 3
	if [ "$apiType" = "ebay" ]; then
		x-terminal-emulator -e python3 -i $main_script_directory/Sub_Applications/Google_Lens_Batcher_METADATA_DEPENDENT/source_script_ebay.py
	else
		x-terminal-emulator -e python3 -i $main_script_directory/Sub_Applications/Google_Lens_Batcher_METADATA_DEPENDENT/source_script.py
	fi
	echo "AI image file renamer completed."
	echo
	sleep 3
else
	cp -r "$full_titler_input_dir"* "$full_titler_output_dir"
fi


cp -r "$full_titler_output_dir"* "$full_autocropper_input_dir"

#Image cropper call...
if [ "$croppingDecision" = "y" ]; then
	echo "Starting Batch Image Cropper..."
	echo
	sleep 3
	x-terminal-emulator -e python3 -i $main_script_directory/Sub_Applications/Autocropper/source_script.py
	echo "Batch Image Cropper completed."
	echo
	sleep 3
else
	cp -r "$full_autocropper_input_dir"* "$full_autocropper_output_dir"
fi


#File organizer/consolidator call...
cp -r "$full_extractor_output_dir"* "$full_consolidator_input_dir" #copying metadata files from metadata extractor to consolidator program if there are any...
cp -r "$full_autocropper_output_dir"* "$full_consolidator_input_dir" #copying cropped image files as well as their respective metadata from each respective sub application's output directory...
echo "Starting Listing Organizer/Consolidator..."
echo
sleep 3
x-terminal-emulator -e python3 -i $main_script_directory/Sub_Applications/Listing_Consolidator/source_script.py
echo "Listing Organizer/Consolidator completed."
echo
sleep 3

#Copying finalized results back to main output folder and doing temporary folder cleanup...
cp -r "$full_consolidator_output_dir"* "$full_main_output_dir"
echo "Returning finalized results back into main output folder..."
echo
sleep 3
if [ "$inBetweenDecision" = "y" ]; then
	echo "Checking for any in-between images not used for original folder creation/AI product identification..."
	x-terminal-emulator -e python3 -i $main_script_directory/Sub_Applications/In_Between_Images_Processor/source_script.py
	echo "In-between image processing completed."
	echo
	sleep 3
fi
#removing any temporary files AND SUBFOLDERS (***PATCHED***) in each relevant child directory from any previous instances of this program running... (POST Batch Run)
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

echo
echo "End of program. Enter 'exit(),' CTRL+D, or force close GUI window to exit. This program will automatically close in 60 seconds. Please be sure to view logs in terminal if needed."
read -p " " </dev/tty
sleep 60
