
---

### Week 2

---
After resizing my old blog layout images, it occurred to me that what if I added more images, I like designing and in between changing and improving those designs.  I meant more designed new images that I could customise the width to fit the new blog layout. Where would I have to put them, certainly it's not in my shell script image source directory that  I use for resizing images.
So I thought okay, what if I tweak the shell script code, where I set up a flag that if the new image fits the resized dimension, don’t resize the image, just move it to the directory directly and log it? Honestly, I did that because I needed the logging to track my image pathway, I could easily just create another folder, and store my normal images in there but I need the logs. I did try to do and it was unsuccessful kind of because I wanted it to function in a certain way.

After writing the script, I executed it and it did something funny. I shoved in normal images with recycled images that I used imagemagick to resize via the shell script in my source directory. The code was executed and echoed “Resized and moved”. It moved a copy of the images to their various destination like it was resizing. Usually, when an image is resized, it makes a copy leaving behind the original image in the source directory, and then I executed it again, then the code was like “I recognise these images don't need resizing” to the original normal and recycled resized images in the source directory, “let's move you to where you belong”. It moved them and replaced their copy in their various destination directories, leaving no image in the source directory. I was like “Oh! It worked” till I opened the logs and behold, cluttered with doubled logs, Although I did try to use chatgpt for error correction to fix it, chatgpt helps with fixing my codes, I am really bad at structuring codes even when I know them. Sample below of how the logs looked like:

![logsampleimg](https://github.com/23W-GBAC/Azukaego_blog/assets/132351500/c4889db6-148b-4254-96f0-0278074a5826)

If anybody takes a go at [it]([shell_script/blogimage_resize_or_move](https://github.com/23W-GBAC/Azukaego_blog/blob/f7b4f13314156f23128658c156fcd12773eaa9fd/shell_script/blogimage_resize_or_move.sh)) and can help where I did wrong, would be grateful, I gave up and thought of an alternative method to log my entire blog repository image pathway anytime they are added anywhere in any folder. I recently just started learning Python script via Zed Shaw’s learning Python the hard way and with scripting, you can copy files, write into files, read files from the terminal(pg 42-76) and [Programming with mosh](https://youtu.be/_uQrJ0TkZlc?si=GUMYQwsguC0fTGA_) on YouTube, decided to log with python script instead. Time to roll out the pseudocode!  

Pseudocode:
Step 1: Create a definition for getting my image files from my entire blog repository directory except for the source ’image’ directory, because it is purely used for storing images that need resizing and their pathways do not need to be logged, don’t want unnecessary clutter.

Step 2: Last time I used a text file to log pathways, it was a mess to the eyes, especially when one pathway and file name is longer than the rest, l would like to log it into a markdown file, so we create a function to log the pathway of the image files, we are getting and we write into the mdfile using an open() in write mode methods and after writing the pathway into the MD file, let's use the sort() method to organize, I do love organizing. 

Step 3: I have the habit of multitasking, alternating between files, so let us put a time prompt for updating the logging, it helps if i am not ready to use an image and just testing  a bunch of images for my HTML and not ready to update the log or log it, we can decline with a ‘no’ and put the script to sleep till we are ready to log besides I already have a bash script and don't want them to run concurrently with each other

Step 4: I should use cron, but then I came short on how to integrate time properly and how it would integrate properly with my code this is when chatgpt was summoned and gave it my sickly-looking patches of code and that was when watchdog and argparse came in with chatgpt integrating it properly.

```json

import os
import time
import argparse
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

```

These are modules and libraries to provide operating system-dependent functions, offer time-related functions, monitor file system and help determine the structure of the script to get information based on the script pattern. Simply, they help keep an eye on a folder to see if anything changes.

```json

exclude_folder = None  # Defining it globally

```

This part was suggested to me by pycharm when I included exclude_folder, suggesting I define it globally. To the best of my research, for example, you know when you open a Word doc it automatically the name is “untitled1”, that is its default name till you decide to change its name. In this case, that is how it works, exclude default is none, till I use –- exclude in the terminal with the name of the folder I want to be excluded. If I don't use exclude, it excludes nothing and scans the whole directory and also allows my program to run without problems, because when it comes to Python script, the number of arguments input would not run unless you input the correct arguments required. I learned that the hard way 😣 learning Python.

```json


# Function to get image files in a directory excluding a specific folder
def get_image_files(directory):
    global exclude_folder  # Access the global variable

    image_files = []
    for root, dirs, files in os.walk(directory):
        if exclude_folder in dirs:
            dirs.remove(exclude_folder)  # Exclude the specified folder from the search
        for file in files:
            if file.lower().endswith((".png", ".jpg", ".jpeg", ".gif")):
                image_files.append(os.path.join(root, file))
    return image_files

```
One of the amazing things I am fascinated by is the Python language, it feels like writing an English statement, as somebody who is intermediate in shell and c programming, I will pick Python any time of the day because it gives me hope that, maybe i am not bad at structuring codes 😂. In the def image directory, we declare image_files iwith an empty list denoted by a square bracket. The os.walk(), is like for example, you live in a huge house and you are upstairs with your mum and she wants you to go and get your younger siblings for dinner, too bad for you, you are not with your phone to call them to know exactly where they are to go get them. So as you walk down the stairs, you search room by room to try and find them. That is what .walk() does in the operating system. Since one of your siblings has eaten their dinner, your mum tells you not to get them, which is what .remove() does to exclude_folder.

if file.lower().endswith((".png", ".jpg", ".jpeg", ".gif")): basically means your mum giving you criteria for getting your siblings, If they are not washed up for dinner, they shouldn’t come. This means if they don't end with their extension in lowercase, append not their pathway, just the pathways with this file extension ending.

```json

# Function to log image pathways to a Markdown file, excluding a specific folder
def log_image_pathways(directory, md_path, exclude=None):
    global exclude_folder
    exclude_folder = exclude  # Update the global exclude_folder variable
    image_files = get_image_files(directory)

    # Writing image paths to the provided MD file
    with open(md_path, 'w') as md:
        md.write("| Image Name                   | Pathway                             |\n")
        md.write("|------------------------------|-------------------------------------|\n")
        for file_path in sorted(image_files):
            image_name = os.path.basename(file_path)
            md.write(f"| {image_name} | {file_path} |\n")

```
Writing the pathway in the md file in markdown format using the open() method in write 'w' mode and sorting the from ascending order using the file basename.

```json


# Function to prompt for updates and call the logging function
def prompt_and_update(directory, md_file, exclude):
    while True:
        answer = input("Do you want to update your list now? (yes/no): ")
        if answer.lower() == 'yes':
            log_image_pathways(directory, md_file, exclude)
            break
        elif answer.lower() == 'no':
            time.sleep(10)  # Wait for ten seconds before prompting again
        else:
            print("Please enter 'yes' or 'no'.")

```
This is prompt function for updating the list and calling the function using "while true:" to keep the prompt from constantly prompting endless response, .lower() in this statement in this case, helps convert the string input to lowercase incase i input the prompt in uppercase, If answer is no, it puts executing or updating it to sleep depending on the secs set before it prompts again, in this case i set it to 10secs to test if it prompts again after putting it to sleep, but in the main code, i set it to 3600secs which to prompt every hour or can be set to 5 or 6hrs

```json

# Class to handle file system events (e.g., file creation)


class ImageHandler(FileSystemEventHandler):
    def __init__(self, directory, md_path, exclude=None):
        super().__init__()
        self.directory = directory
        self.md_path = md_path
        self.exclude = exclude

```
This keeps an eye on changes in the directory like a new file being created. It is more like, the security guard at your house, whenever you have a visitor, or new tenants or have the electrician, the security guard which is the image handler, watches and log all the details of their coming and going in a sign in or out notebook and the exclude are the people the security guard has been instructed not to let in. The events are the people going in and coming out and usually activities like file creations, deletion and modification, is the repairman showing up on the date that was not appointed for him, which is an unexpected event. Self mean within the specified directory.

```json

def on_any_event(self, event):
        prompt_and_update(self.directory, self.md_path, self.exclude)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Log image pathways to a Markdown file, excluding a specific folder.")
    parser.add_argument("directory", help="Directory to watch for image files")
    parser.add_argument("md_file", help="MD file to write the paths")
    parser.add_argument("--exclude", help="Folder to exclude from search", default=None)
    args = parser.parse_args()

    event_handler = ImageHandler(args.directory, args.md_file, exclude=args.exclude)
    observer = Observer()
    observer.schedule(event_handler, args.directory, recursive=True)
    observer.start()

    prompt_and_update(args.directory, args.md_file, args.exclude)

    observer.stop()
    observer.join()


```
So, you know stewie from family guy, the smart talking baby, in this scenario, he is the imagehandler, good observer and decision maker, brian is on_any_event always vigilant ready to act upon detecting an event, have you ever seen brian focused when he suddenly sees a squirrel to chase or the mailman. Lois is the main script (if__name__ == “__main”) coordinating and managing the household. So it is basically stewie, setting a security system to monitor the house, i mean stewie is very smart and instructs Brain to watch out for any usual events while lois is responsible for starting and stopping the security system, when she instructs stewie to start to monitor(observer.start()), and when decides to end the monitoring, she ask stewie to stop(observer.stop()). During the process of start and stop, brain was vigilant under the guidance of the imagehandler stewie while the entirety of the process is managed by the lois, the main script.

To make it executable with necessary permission use the:
```json

chmod u+x loggingall.py

````
Running the script from the terminal:
```json

python3.12 loggingall.py . logs/log_for_all_repo_image.md --exclude images

````
Append the pathway of your script pathway to nano, to enable run from anywhere in the terminal or append the pathway to an aliases and add to nano .bashrc file, call it from any where in your terminal, usually if you try to run it outside the current directory, without using the relative or full pathway, it would say directory not found. 
the script can be used to monitor and log folder pathways also, just include the extension
