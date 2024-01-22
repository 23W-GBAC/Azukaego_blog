
# AUTOMATIONS
___

## WEEK ONE  (Resizing images)

___

I started my blog by being too reliant on the GitHub theme given the type of layout and design, I wanted and due to the limitation, I had to strip down everything and started all over with an index.html with my own customized layout leaving me with a new blog layout and images that needS resizing to fit the new layout, to combat this issue using shell script to automate the resizing.

The first step in doing that, writing a pseudocode, one of my biggest setbacks is having an idea but not structuring them properly and doing a pseudocode helps.

Pseudocode:<br>
Step 1- create a source folder, where I will store all the images.<br> 
Step 2 - Create a 3-destination folder to accommodate different sizes of images.<br> 
Step 3 - After creating a function for resize, I think I should create a dimension flag that if for example, If an image in the source directory is within a big-sized pixel, It is resized and sent to a destination file for a big resized image and also apply to smaller pixel after they get resized, they are sent to a smaller pixel directory and the resizing is depended on the range dimension I want and this can be resized to fit my new blog layout.<br>
Step 4 - I have to be able to put a flag warning where if the files already exist after resizing they don't get resized again to prevent unneeded resizing and clutter.

The code:
Before writing the code I had to google the software app for resizing I could use from the command line and it was [imagemagick](https://imagemagick.org/script/download.php) and ffmpeg that was reconmended. I tried to use ffmpeg and had problems with installation. It is user-friendly and easy to install. Since I use Windows, I installed the binary release version and it gets installed directly into the environment variables of my system and doesn’t need the path of the installed application to be copied into the path of my system variables. So to test if it has been installed I used the command:

```json
$ convert –-version 
```
And it prints out the version

(a) Creating the folders: creating the source folder where all the images would be and a destination folder where all the resized images would be sent: 

```json
$ mkdir images
$ mkdir output_images
$ cd output_images
$ mkdir blog_banner_images
$ mkdir blog_post_article_images
$ mkdir blog_post_banner_images
```

images/ is the source directory.<br>
output_images/ is the  directory which contains three other destination directories under it.<br>
blog_banner_images/ is the destination directory one.<br>
blog_post_article_images/ is the destination directory two.<br>
blog_post_banner_images/ is the destination directory three.<br>

(b) Created a .sh extension file named “blogimage”.<br>
(c) Added the line below to the first line of the code in the .sh extension file.<br>

```json
#!/bin/bash
```

This line tells that the script should be run using the bash shell, followed by
 
```json
# set -x
```

It was commented out after debugging for the script to know which line has issues but can also be uncommented to check when more changes are added add. If required.<br>

(d) Added our source and destination directories with their pathways

```json
source_dir="images"
destination_dir1="output_images/blog_banner_images"
destination_dir2="output_images/blog_post_banner_images"
destination_dir3="output_images/blog_post_article_images"
log_dir="logs"
```

Meanwhile, log_dir is a variable that holds the directory where the log files will be stored or created.<br>

```json
mkdir -p "$log_dir"
log_file="$log_dir/copied_images_pathway_logs.txt"

if [ -s "$log_file" ]; then
    printf "\nAppending to the log file...\n\n"
else
    printf "%-60s | %-60s\n" "Resized Log" "Destination Log" > "$log_file"
fi
```

The mkdir -p “$log_dir” variable is used to create a directory named "logs" if it doesn't already exist.<br> 
To manage the resize output pathway, copied_images_pathway_logs.txt is the file appended to log_dir. I added this because if I was dealing with a huge number of images like 50, how would I be able to track or know their pathways, i tested it with 4 images and it was annoying searching the files to copy their pathway to append to my html layout. So with the log, it was easier to find an image pathway and to make it more easier, I named all my images for their intended purpose. For example, Mary’s article blog post header image is named “mary” so when I check the log and see “mary.png”, i just copy its pathway and append it where it is supposed to be in the HTML blog layout. 

This conditional check ([ -s "$log_file" ]) verifies if the file specified by $log_file exists and has non-zero size (-s flag) and If the log file exists and has content (-s "$log_file" is true), it executes the next line of code which is the printf "\nAppending to the log file...\n\n": which Prints a message indicating that content is being appended to the log file.<br>

If the log file doesn't exist or is empty (-s "$log_file" is false). It executes the code block after else printf "%-60s | %-60s\n" "Resized Log" "Destination Log" > "$log_file":<br>
Creates a new log file with header information ("Resized Log" and "Destination Log") and redirects (>) this information to the specified log file ("$log_file"). 

The [log](logs/copied_images_pathway_logs.txt) file can be checked to see the sample in the text file, to view how it looks like. The output %-60s | %-60s\n  represents the first string argument that will be printed, which is for example, mary.png has been resized and copied to Mary.png destination file followed by | and a space. 

The second specifier %-60s represents the second string argument that will be printed.
"\n" is a newline character, which will be the destination pathway of where the .png was copied into, causing the output to move to the next line after printing these two formatted strings. 

(e)Added the function definition to resize the image:<br>

```json
resize_image() {
 local input="$1"
 local output="$2"
 local new_size="$3"
```

Resize images take three arguments, which are the input, output and the new size of the image and the $1, $2, $3 represents the input path, the output path and the new size path for the image.<br>

```json
 if [ -f "$output" ]; then
```

This conditional block checks if the output file exists.<br>

```json
   echo "$(basename -- "$input") already exists in $(basename -- "$output")"
```

Then If the output file exists, it echoes a message indicating that the input file already exists in the output directory

```json
  else 
  if convert "$input" -resize "$new_size" -quality 80 "$output"; then
    printf "%-60s | %-60s\n" "Resized $(basename -- "$input") and copied to $(basename --    "$output")" "Destination: $output" >> "$log_file"
  else
   echo "Error: Resize operation failed for $(basename -- "$input")"
  fi
 fi
}
```

NB:<br>
"fi" is used to end an “if” statement.<br>
"then" is used with "if" statement to mark the beginning of the code block or code line that should be executed.<br>
do is used with the "for" statement to indicate the beginning of the block of code that should be repeated in each repeatition of the loop.<br>
done is used to end a “for” statement.<br>

If the output file doesn't exist, the script attempts to resize the image with imagemagck that uses the command “covert” to resize the input file ($input) to the specified new size ($new_size) and sets the quality to 80%. The output is saved to the $output file, then Checks the success or failure of the convert operation.<br> 

If the resize is successful, it logs the details of the resized image and its destination pathway into a log file ($log_file) to able to keep track of the pathways without constantly having to check the directories for where which image is in which directory and if it wasn’t successful, it echoes an error message indicating that the resize operation failed for the input file.<br>

```json
for file in "$source_dir"/*.{jpg,png}; do
```

This block initiates a loop that iterates through each file in the "$source_dir" where the image is stored in the directory that has a .jpg or .png extension.<br>

```json
    if [ -f "$file" ]; then
        dimensions=$(identify -format "%w %h" "$file")
```

checks if the current file ($file) is a regular file and uses the identify command from ImageMagick to retrieve the width and height of the current image file and stores the result in the dimensions variable after comparing the image dimensions obtained from the “identify” command with the specific ranges below:<br> 

```json
        # Performing resize based on image dimensions
        if echo "$dimensions" | awk '{exit !($1>=700 && $1<=3000 && $2>=700 && $2<=3000)}'; then
            resize_image "$file" "$destination_dir1/$(basename -- "$file")" "650x727"
        elif echo "$dimensions" | awk '{exit !($1>=210 && $1<=400 && $2>=210 && $2<=410)}'; then
            resize_image "$file" "$destination_dir2/$(basename -- "$file")" "200x200"
        elif echo "$dimensions" | awk '{exit !($1>=130 && $1<=199 && $2>=130 && $2<=199)}'; then
            resize_image "$file" "$destination_dir3/$(basename -- "$file")" "120x120"
    	fi
	fi
done
```

So I put a dimension range. In my blog layout, the images with bigger width and height is for the blog header layout. Images with mid-width and height dimension ranges are resized to fit into the blog post header images and smaller widths and heights are resized for the blog post article. For example resized image of width and height of 650X727 are sent to destination_dir1, resized image of width and height of 200x200 are sent to destination_dir2 while resized image of width and height of 120x120 are sent to destination_dir3.<br>

Also, more dimensions can be added to accommodate the blog logo width and height and can also be resized to prefered dimensions and sent to a different destination or single destination depending on the needs of how organized you want your folder to be. The dimension of the image is echoed and piped into where  “awk” checks whether the dimension of the image falls within the dimension range and (!) represents not. If it does not fall in the range it exits and moves on to the next line of code and does the same thing.

To make the script executable:

```json
$ chmod u+x blogimage.sh
```

To enable my resize image automation anytime my terminal runs. I can put my images anytime and it gets resize by doing:

```json
$ nano ~/.bashrc
```
And then add my blogimage.sh pathway to execute when the terminal runs.

___

### [WEEK TWO](automation_two.md)  | [WEEK THREE](automation_three.md)   |

