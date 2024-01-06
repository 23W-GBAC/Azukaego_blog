#!/usr/bin/env python3.12

import os
import time
import argparse
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

exclude_folder = None  # Define it globally


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


# Function to prompt for updates and call the logging function
def prompt_and_update(directory, md_file, exclude):
    while True:
        answer = input("Do you want to update your list now? (yes/no): ")
        if answer.lower() == 'yes':
            log_image_pathways(directory, md_file, exclude)
            break
        elif answer.lower() == 'no':
            time.sleep(10)  # Wait for an hour before prompting again
        else:
            print("Please enter 'yes' or 'no'.")

# Class to handle file system events (e.g., file creation)


class ImageHandler(FileSystemEventHandler):
    def __init__(self, directory, md_path, exclude=None):
        super().__init__()
        self.directory = directory
        self.md_path = md_path
        self.exclude = exclude

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
