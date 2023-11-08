#!/bin/bash
#for peace of mind...
sleep 1

main_script_directory="$(dirname "$0")" #directory of THIS script
apiDecision="NULL"
apiType="NULL"
inBetweenDecision="NULL"
imageColoringDecision="NULL"
backgroundRemovalDecision="NULL"
croppingDecision="NULL"
metadataDecision="NULL"
coloringScript="NULL"
config_file="Config.txt"
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

#Clearing out file history text file...
truncate -s 0 $file_history

#Generating a few new lines in history file to serve as future placeholders for each setting line.
printf '\n%.0s' `seq 1 1` >> "$file_history"

###Variable adjustment from Configuration File data Section###

apiDecision=$(sed -n '2p' "$config_file")
apiType=$(sed -n '3p' "$config_file")

if [ "$apiDecision" = "useAPIRenamer=NO" ]; then 
	apiDecision="n"
	apiType="NULL"
else
	apiDecision="y"
	if [ "$apiType" = "apiType=EBAY" ]; then
		apiType="ebay"
	else
		apiType="google"
	fi
fi

inBetweenDecision=$(sed -n '4p' "$config_file")

if [ "$inBetweenDecision" = "inBetweenImages=NO" ]; then 
	inBetweenDecision="n"
else
	inBetweenDecision="y"
fi

###
coloringScript=$(sed -n '1p' "$config_file")

if [ "$coloringScript" = "coloringOperationScript=NULL" ]; then 
	imageColoringDecision="n"
	coloringScript="NULL"
else
	imageColoringDecision="y"
	#removing coloringOperationScript= part from config file data...
	edited_string="${coloringScript//coloringOperationScript=/}"
	coloringScript=$edited_string
fi

###BUILD OUT!###


backgroundRemovalDecision=$(sed -n '5p' "$config_file")

if [ "$backgroundRemovalDecision" = "backgroundRemoval=NO" ]; then 
	backgroundRemovalDecision="n"
else
	backgroundRemovalDecision="y"
fi

croppingDecision=$(sed -n '6p' "$config_file")

if [ "$croppingDecision" = "cropImages=NO" ]; then 
	croppingDecision="n"
else
	croppingDecision="y"
fi

metadataDecision=$(sed -n '7p' "$config_file")

if [ "$metadataDecision" = "generateMetadata=NO" ]; then 
	metadataDecision="n"
else
	metadataDecision="y"
fi



###Variable adjustment from Configuration File data Section END###

if [ "$imageColoringDecision" = "y" ]; then #Bulk image coloring call...
	cp -r "$full_main_input_dir"* "$full_coloradjuster_input_dir" #copying all files from main input directory to Color Adjuster's Input Directory if the image coloring operations are used...
	echo "Starting bulk image coloring program based on user-defined coloring operations script..."
	echo
	python3 $main_script_directory/Sub_Applications/Color_Adjuster/source_script.py &
	wait
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
	rembg p --bgcolor=255 255 255 255 -ppm $full_bgremover_input_dir $full_bgremover_output_dir &
	wait
	echo "Batch image background removal complete."
	echo
	sleep 3
	echo "Generating history data for image background removal program..."
	echo
	x-terminal-emulator -e python3 $main_script_directory/Sub_Applications/rembg-main/history_generator.py
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
	python3 $main_script_directory/Sub_Applications/Listing_Metadata_Extractor/source_script.py &
	wait
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
		python3 $main_script_directory/Sub_Applications/Google_Lens_Batcher_METADATA_DEPENDENT/source_script_ebay.py &
		wait
	else
		python3 $main_script_directory/Sub_Applications/Google_Lens_Batcher_METADATA_DEPENDENT/source_script.py &
		wait
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
	python3 $main_script_directory/Sub_Applications/Autocropper/source_script.py &
	wait
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
python3 $main_script_directory/Sub_Applications/Listing_Consolidator/source_script.py &
wait
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
	python3 $main_script_directory/Sub_Applications/In_Between_Images_Processor/source_script.py &
	wait
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

echo "Program completed. Type exit() or close window to close program."
