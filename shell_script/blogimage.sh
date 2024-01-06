#!/bin/bash

# set -x
# source and destination directory with their pathways and the log directory
source_dir="images"
destination_dir1="output_images/blog_banner_images"
destination_dir2="output_images/blog_post_banner_images"
destination_dir3="output_images/blog_post_article_images"
log_dir="logs"


mkdir -p "$log_dir"
log_file="$log_dir/copied_images_pathway_logs.txt"

if [ -s "$log_file" ]; then
    printf "\nAppending to the log file...\n\n"
else
    printf "%-60s | %-60s\n" "Resized Log" "Destination Log" > "$log_file"
fi

# function for resizing the image
resize_image() {
    local input="$1"
    local output="$2"
    local new_size="$3"

    if [ -f "$output" ]; then
        echo "$(basename -- "$input") already exists in $(basename -- "$output")"
    else
        if convert "$input" -resize "$new_size" -quality 80 "$output"; then
            printf "%-60s | %-60s\n" "Resized $(basename -- "$input") and copied to $(basename -- "$output")" "Destination: $output" >> "$log_file"
        else
            echo "Error: Resize operation failed for $(basename -- "$input")"
        fi
    fi
}

for file in "$source_dir"/*.{jpg,png}; do
    if [ -f "$file" ]; then
        dimensions=$(identify -format "%w %h" "$file")

        # Perform resize based on image dimensions
        if echo "$dimensions" | awk '{exit !($1>=700 && $1<=3000 && $2>=700 && $2<=3000)}'; then
            resize_image "$file" "$destination_dir1/$(basename -- "$file")" "650x727"
        elif echo "$dimensions" | awk '{exit !($1>=210 && $1<=400 && $2>=210 && $2<=410)}'; then
            resize_image "$file" "$destination_dir2/$(basename -- "$file")" "200x200"
        elif echo "$dimensions" | awk '{exit !($1>=130 && $1<=199 && $2>=130 && $2<=199)}'; then
            resize_image "$file" "$destination_dir3/$(basename -- "$file")" "120x120"
    	fi
	fi
done