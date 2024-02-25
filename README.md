###ABOUT###

Automatic Bulk Image Formatter and Renamer is a collective program chain frontend for editing images in bulk. It features programs that can automatically crop images, remove image backgrounds via AI, rename images to matching similar images found via either the Google Vision or Ebay API, edit image pixel maps, and generate image metadata text files via Google Vision (experimental).

###LICENSING###

Please see LICENSE file in main program directory for software licensing information.

###SETUP###

-This program depends on a collection of local Shell Script, Python, Python Imaging libraries that need to be setup in your computing environment listed below. 

-For metadata text file generation and AI image identification and renaming features to work properly, your system also needs to be configured to use the official Google Cloud and Vision API as well as a local unofficial Python Ebay API frontend and a fresh Production Environment O'Auth user token string generated from the Ebay Developer website THAT NEEDS TO COPIED OVER AND OVERWRITE ALL TEXT IN THE "ebayUserAccessToken.txt" FILE FOUND IN THE MAIN PROGRAM DIRECTORY EVERY FEW HOURS. TO BE CLEAR, THAT TOKEN EXPIRES AND IS UNUSABLE AFTER EVERY FEW HOURS FOR SECURITY PURPOSES.

-While inconclusive, it is tentatively recommended to use the program on a commonly supported Debian-based Linux operating system. We tested ours on an x64 xUbuntu 23.10 "fresh" installation as of time of writing. The list below describes all of the libraries we had to install on our system to satisfy the program package dependencies as of time of writing. Please note that the exact list of package dependencies and specific installation methods may vary from system to system.

-NOTE: AFTER INSTALLING AND CONFIGURING THE DEPENDENCIES LISTED BELOW, IT IS STRONGLY RECOMMENDED TO START THE PROGRAM IN DIAGNOSTIC MODE FIRST TO ENSURE THAT EACH DESIRED "SUB PROGRAM" IS NOT BREAKING DUE TO A SYSTEM-WIDE DEPENDENCY/CONFIGURATION ISSUE. ONE BROKEN SUB PROGRAM MAY ALSO BREAK ANY FOLLOWING CHAIN OF SUB PROGRAMS ENABLED DURING A USER-ELECTED BULK IMAGE EDITING PROCESS. Diagnostic Mode can be accessed by running the "RUNME_diagnostic_mode.sh" file located in the main program directory with xTerm (other terminal programs may work; we just recommend this because the program was predominantly tested with xTerm specifically during its development.) Diagnostic Mode asks you which sub programs you would like to use in your bulk image processing "chain," and then puts each sub application on hold until you enter in "exit()" at the input line. This hold shows all terminal output from each sub program in the chain, including script breaks that may occur with dependency/configuration issues.

-Be sure that AT LEAST the following are properly installed and/or configured on your system before starting the program. Please note that your environment may not be limited to this list and that actual installation commands may vary:
	1.) Make sure that you have successfully created a Google Cloud and Ebay Developer account online. Recommended Google Cloud account setup commands that tend to be easiest will be mentioned in the listings below. If you get stuck or want to check if your setup methods vary with your system, please see https://cloud.google.com/sdk/docs/install-sdk
	2.) Install pip or python3-pip
	3.) Install numpy 
		sudo apt install python3-numpy; May need pipx; pipx install radian
	4.) Install xTerm
	5.) Install rembg
		pip install rembg
	6.) Install rembg CLI (Command Line Interface)
		pip install rembg[cli]
	7.) Install ebaySDK (Unofficial Python Ebay SDK Library) 
		pip install ebaysdk
	8.) Double-check that "curl" and "apt-transport-https" are installed: (Note: Your specific procedures to accomplish this task on your operating system may vary. Please see https://cloud.google.com/sdk/docs/install-sdk)
		sudo apt-get install apt-transport-https ca-certificates gnupg curl sudo
	9.) If you have the old snap package, google-cloud-sdk, installed, remove it at the command line: (Note: Your specific procedures to accomplish this task on your operating system may vary. Please see https://cloud.google.com/sdk/docs/install-sdk)
		snap remove google-cloud-sdk
	10.) At the command line, install the gcloud CLI snap package: (Note: Your specific procedures to accomplish this task on your operating system may vary. Please see https://cloud.google.com/sdk/docs/install-sdk)
		snap install google-cloud-cli --classic
	11.) Intialize Google Cloud locally. (Note: Your specific procedures to accomplish this task on your operating system may vary. Please see https://cloud.google.com/sdk/docs/install-sdk)
		gcloud init
	12.) Select the Google Cloud project that you created either locally or on the online Google Cloud Console:
		gcloud config set project PROJECT_ID edit
	13.) Enable the Cloud Natural Language API either locally or through the online Google Cloud Console:
		gcloud services enable language.googleapis.com
	14. Create local authentication credentials for your Google Account locally:
		gcloud auth application-default login
	15. Install Python client-side-library for google-cloud-language
		pip install --upgrade google-cloud-language
	16. Install iPython
		pip install ipython OR sudo apt install python3-ipython
	17. Double-check that Google Vision API is enabled on your Google Cloud account either locally or through the Google Cloud Online Console
		gcloud services enable vision.googleapis.com
	18. Install Google Vision Python API locally via PIP:
		pip install google-cloud-vision
	19. Install Python image-enhancement library (for image recoloring)
		pip install image-enhancement
	20. Install imutils
		pip install --upgrade imutils
	21. Install PyQt5 for GUI purposes.
		pip install pyqt5
	22. Make sure "xterm" is the default program for running shell files in any GUI desktop environment system as well as double-checking to make sure that the shell files have executable and read-write permissions. Some other terminals may try running multiple shell instances at the same time - this program is not designed to work that way. All sub application instances must be sequential for each sub application in the bulk image processing "chain" to work properly. No parallel computing allowed.
	23. Due to lack of font .ttf file location and indexing standardization on Linux distributions, please make sure that you have installed "DejaVuSans.ttf" globally on your system for effective indexing at this time when using the text stamper in the Repixelater sub application. Most distributions should have it by default, but just in case, double-check that if there are any issues.

###USAGE###

#General Usage Notes:#
-Be sure to follow setup instructions first BEFORE running the program conventionally with the "RUNME.sh" program located in the main program directory.

-Do NOT rename the main program directory, "Automatic_Formatter_Master_Program." We would also recommend putting the main program directory into a directory that is not too "deep," as potential too long of file name and directory errors might otherwise occur. We recommend placing the program up to the depth of your Desktop directory at the most.

-All images that you would like to be bulk edited by the bulk image processing "chain" of sub programs should be placed inside the "Master_Input_Folder" of the main program directory before beginning processing. Please be sure to only use JPEG or PNG image file types in there, and try to avoid inputted image file names that have special characters in them. While we have dutifully tried to improve stability with handling irregular file names, some special cases may have slipped through the cracks at this time.

-All outputted files will be outputted into corresponding folders in the "Master_Output_Folder" directory located in the main program directory. Corresponding directories for each inputted/edited image will always be generated, but the names of the directories will depend on if you have enabled the AI image renamer subprogram or not. The original image files from the "Master_Input_Folder" will also be copied into the corresponding folders with the tag "_ORIGINAL" at the end of the file name before the extension.

-Be prepared for temporary mass storage "bloat" that will temporarily occur as the program runs, as image files from the "Master_Input_Folder" will be temporarily copied into each of the local input directories and subsequent output directories for each subprogram that is enabled for the bulk image editing process. The files are copied and not moved about those directories due to potential diagnostic reasons while the subprograms are running. Those folders are cleared when the application finishes all subprograms in the chain without issue and copies the finalized edited images into the "Master_Output_Folder." 

-Images to be bulk edited follow the following flow pattern below from step 1 to step 8, but any subprogram can be skipped over depending on user preference. Please also note that the image files are directly fed the preceeding subprogram's output to the next, if applicable, subprogram's input - with the exception of the Metadata Generator, as it functions on a separate "input chain," using unedited original images as its source. For example, a repixelated outputted image from the Repixelater will be fed into the input of the Background Remover subprogram if both are enabled in the subprogram chain and so forth:

--1.) [Get Images from "Main_Input_Folder"] -> 2.) Subprogram: Repixelater -> 3.) Subprogram: Background Remover -> 4.) Subprogram: Metadata Generator -> 5.) Subprogram: AI Filename Renamer -> 6.) Subprogram: Automatic Cropper -> 7.) [Consolidate Edited Files into Corresponding Folders in "Main_Output_Directory"] -> 8.) Subprogram: In-between Images Processor
##

#Repixelater Usage#
-This subprogram adjusts the pixel mapping/coloration of images in bulk. It runs based on a string of custom commands with their parameter numbers (if applicable) directly after each command in paranthesis. Each command is separated by a comma with spacing. The commands are followed from left to right of the string. 

-This is an example of a program that stamps "Honey, I shrunk the kids." in 96-point blue font 1/4 relative image length and 1/4 relative image height, rotates the image 40.1 degrees clockwise, mirrors it vertically across the y-axis, and colorizes it green:
--textstamp("Honey, I shrunk the kids.", 0.25, 0.25, 96, 0, 0, 255), rotate(40.1), mirror_vertical, colorize(0, 255, 0)

-These are the commands that can be used in Repixelater strings/scripts. Be mindful of the string/script syntax, as improper syntax may break the subprogram at this time, in spite of recent efforts to mitigate those risks:

--bbhe (Brightness Preserving Histogram Equalization) {No Parameters}
---Kim, Yeong-Taeg.
---Contrast enhancement using brightness preserving bi-histogram equalization.
---IEEE transactions on Consumer Electronics 43, no. 1 (1997): 1-8.

--bhepl (Bi-Histogram Equalization with a Plateau Limit) {No Parameters}
---Ooi, Chen Hee, Nicholas Sia Pik Kong, and Haidi Ibrahim.
---Bi-histogram equalization with a plateau limit for digital image enhancement.
---IEEE transactions on consumer electronics 55, no. 4 (2009): 2072-2080.

--bpheme (Brightness Preserving Histogram Equalization with Maximum Entropy) {No Parameters}
---Wang, Chao, and Zhongfu Ye.
---Brightness preserving histogram equalization with maximum entropy: a variational perspective.
---IEEE Transactions on Consumer Electronics 51, no. 4 (2005): 1326-1334.

--brightness{Decimal Factor}	
---Adjusts image brightness.
---This can be used to control the brightness of an image. An enhancement factor of 0.0 gives a black image, a factor of 1.0 gives the original image, and greater values increase the brightness of the image.

--colorize{[Red Color Integer Value 0-255(Inclusive)], [Green Color Integer Value 0-255(Inclusive)], [Blue Color Integer Value 0-255(Inclusive)]}
---Colorizes an image with a given color, presented in an integer RGB format. Each RGB value is represented as an integer from 0-255 inclusive, passed as 3 arguments in the parameter.

--contrast{Decimal Factor}
---Adjusts image contrast.
---This can be used to control the contrast of an image, similar to the contrast control on a TV set. An enhancement factor of 0.0 gives a solid gray image, a factor of 1.0 gives the original image, and greater values increase the contrast of the image.

--dsihe (Dualistic Sub-Image Histogram Equalization) {No Parameters}
---Wang, Yu, Qian Chen, and Baeomin Zhang.
---Image enhancement based on equal area dualistic sub-image histogram equalization method.
---IEEE Transactions on Consumer Electronics 45, no. 1 (1999): 68-75.

--fhsabp (Flattest Histogram Specification with Accurate Brightness Preservation) {No Parameters}
---Wang, C., J. Peng, and Z. Ye.
---Flattest histogram specification with accurate brightness preservation.
---IET Image Processing 2, no. 5 (2008): 249-262.

--ghe (Global Histogram Equalization) {No Parameters}
---This function is similar to equalizeHist(image) in opencv.

--mirror_horizontal
---Mirrors the image accross the x-axis. Requires no parameter.

--mirror_vertical
---Mirrors the image accross the y-axis. Requires no parameter.

--mmbebhe(Minimum Mean Brightness Error Histogram Equalization) {No Parameters}
---Chen, Soong-Der, and Abd Rahman Ramli.
---Minimum mean brightness error bi-histogram equalization in contrast enhancement.
---IEEE transactions on Consumer Electronics 49, no. 4 (2003): 1310-1319.

--resize{[Float Horizontal Dimension Multiplier Value > 0 ],[Float Vertical Dimension Multiplier Value > 0]}
---Resizes image if the operation code is present. The resizing is done by multiplying decimal factors greater than 0 to the number of horazontal and vertical pixels via passing two parameters - one for each dimension.

--rlbhe (Range Limited Bi-Histogram Equalization) {No Parameters}
---Zuo, Chao, Qian Chen, and Xiubao Sui.
---Range limited bi-histogram equalization for image contrast enhancement.
---Optik 124, no. 5 (2013): 425-431.

--rotate{[Float Image Rotation Degree Value -360.0-360.0(Inclusive)]}
---Manually rotates image if the operation code is present. Any float number between -360.0 to 360.0 inclusive after the rotation keyword is treated as the rotation angle parameter. The positive or negative denotes the direction of the rotation.

--saturation{Decimal Factor}	
---Adjusts image color balance.
---This can be used to adjust the color balance of an image, in a manner similar to the controls on a color TV set. An enhancement factor of 0.0 gives a black and white image. A factor of 1.0 gives the original image. More indefinitely oversaturates the image.

--sharpness{Decimal Factor}	
---Adjusts image sharpness.
---This can be used to adjust the sharpness of an image. An enhancement factor of 0.0 gives a blurred image, a factor of 1.0 gives the original image, and a factor of 2.0 gives a sharpened image. More indefinitely sharpens the image.

--textstamp([Text String], [0 < Relative Location Multiplier Horizontal Dimension Float < 1], [0 < Relative Location Multiplier Vertical Dimension Float < 1], [Font Size Integer > 0], [Red Color Level RGB Integer 0-255(Inclusive)], Green Color Level RGB Integer 0-255(Inclusive)], Blue Color Level RGB Integer 0-255(Inclusive)])
---Adds a text stamp to an image. The user may customize what text is stamped, its location relative to the resolution for each image, font size, and font color, in that argument order. Please note that, at this time, 
---Due to lack of font .ttf file location and indexing standardization on Linux distributions, please make sure that you have installed "DejaVuSans.ttf" globally on your system for effective indexing at this time when using the text stamper. Most distributions should have it by default, but just in case, double-check that if there are any issues.

##

#Background Remover Usage#
-If enabled, this subprogram uses machine learning to try to identify the "subject" of each inputted image and then create an absolute white-colored mask over where it thinks the background of the subject is. The mask color can be optionally be adjusted by adjusting its call in the "Director.sh" and "RUNME_diagnostic_mode.sh" files in the main program directory. Easier color adjustment methods may be implemented in future versions of the program depending on feature demand.

##

#Metadata Generator Usage# (Heavily Experimental and Unstable; May Be Depreciated or Refined in Future Releases Depending on User Demand)
-If enabled, this subprogram reads text found on an image and saves it as optional description, price, shipping dimensions, and shipping weight fields to a generated a text file with "_metadata" at the end of the file name. It's useful for cataloging some image metadata that will later be used when publishing ecommerce listings using the image, for example. Each line is optional and is detected to the corresponding field based on key characters, such as the "$" denoting that it is about price or "x" denoting that the line is for a dimensions field. Each field can be defined by writing lines of text directly into the image prior to running the bulk image editing program with the following syntax example, with each new field being denoted with a semicolon and new line written into the image file. Please note that it is best practice to put the lines of text into a conspicuous and high contrast area of the photo without other text in the picture for best results. We recommend placing the lines in a corner of the image. The metadata generator grabs the lines from the original unedited image and not any edited image, so you do not need to worry about the Background Remover, for example, removing the text before the Metadata Generator has a chance to read the image. Please note that this subprogram is highly dependent on Google Vision and its continuing machine learning models, so the quality of the results will likely vary over time.
--Example of proper field usage, writing high-contrast text in a corner of a given image, denoted as separate lines starting with semicolons:
	; This is the image description.
	; $3.00 <-USD currency only at this time
	; 8x6x4 <-Do not space between "x"
	; 2 lbs 7 oz <-Keep spacing in mind

##

#AI File Renamer Usage#
-If enabled, this subprogram renames the filenames of the inputted image files based on the most similar matching image reported from either the Google Cloud Vision API or the Ebay API depending on user preference. The rename is also reflected in the future corresponding folders that will be generated as well for the image. This feature is useful for automated image identification for organizational purposes, but can have mixed results depending on learning machine models and image quality. At this time, the Ebay API tends to return more descriptive and relevant titles for the images, so it is the more recommend option. The Google Vision API may become depreciated in later releases.

-Please note that the Google Vision API should have all Google Cloud dependencies installed on the system and appropriate configurations setup on both the local system-side and the online Google Cloud account-side. See setup for more details.

-Please note that the Ebay should have all Ebay SDK library dependencies installed on the system and appropriate configurations setup on the online Ebay Developer account. See setup for more details.
--WHEN USING THE EBAY API, IT IS CRUCIAL TO UPDATE THE O'AUTH USER ACCESS TOKEN FROM A PRODUCTION-SIDE APPLICATION OF YOUR CHOICE ON YOUR EBAY DEVELOPER ACCOUNT EVERY FEW HOURS, AS THEY EXPIRE FOR SECURITY PURPOSES. BE SURE TO COPY THE TOKEN STRING INTO THE "ebayUserAccessToken.txt" FILE LOCATED IN THE MAIN PROGRAM DIRECTORY, OVERWRITING ANY PREVIOUS TOKEN AND/OR GARBAGE SPACING OR NEW LINE CHARACTERS IN THE TEXT FILE. See https://developer.ebay.com/ for more details.

##

#Automatic Cropper Usage#
-If this subprogram is enabled, it will try to automatically crop to the edges of the subject in each inputted image. Please note that this program distinguishes the background from the subject in the image based on whether or not it detects the absolute white color in the image pixels. It is designed to work with the Background Remover that, by default, generates a mask around the subject of the same color. If the Background Remover is NOT engaged while the Automatic Cropper is, the subprogram may not deliver the best results.

##

#In-between Images Processor Subprogram Usage:#
-If you have other images from the same lot of images that you would NOT like to be bulk edited but would still like to be organized into the corresponding output folders, you may also optionally place the whole image lot in question - including the files that WILL be edited - into the "Full_Image_Lot_Optional" folder in the main program directory. This is useful if, for example, you are preparing a set of pictures for a listings and you want the main listing photos to be edited but the other images showing closeups or awkward angles of the product to not be edited. Be sure that the In-Between image processor is enabled for this function. The In-Between Image Processor determines which images are to be edited and which images are not based on how the image files are presented in alphabetical order in the "Full_Image_Lot_Optional" folder. 

--For example, let's say that only images "A.jpg" and "D.jpg" are to be edited in given full image lot of images A-Z.jpg. Only A and D would be in the "Master_Input_Folder," while all images A through Z would be in the "Full_Image_Lot_Optional" folder. All images in-between A and D and after D to Z would be considered in-between images and copied to each of the corresponding output folders of A and D.

---Visual Example: A.jpg(To Be Edited), B.jpg-C.jpg(In-between images that will be copied to A.jpg's output folder), D.jpg(To Be Edited), E.jpg-Z.jpg(In-between images that will be copied to D.jpg's output folder.)
### Automatic_Formatter_Master_Program
# Automatic_Formatter_Master_Program
# Automatic_Formatter_Master_Program
