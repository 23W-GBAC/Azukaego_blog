#!/bin/bash

source_dir="images"
destination_dir1="output_images/blog_banner_main_images"
destination_dir2="output_images/blog_side_banner_images"
destination_dir3="output_images/blog_post_banner_images"
destination_dir4="output_images/blog_post_article_images"
log_dir="logs"
unmatched_dir="output_images/unmatched_images"

mkdir -p "$log_dir"
log_file="$log_dir/copied_images_pathway_logs.txt"

if [ -s "$log_file" ]; then
    printf "\nAppending to the log file...\n\n"
else
    printf "%-60s | %-60s\n" "Resized or Moved Log" "Destination Log" > "$log_file"
fi

move_if_same_dimensions_and_resize_if_not() {
    local input="$1"
    local output_dir="$2"
    local dimensions="$3"
    local filename
    filename=$(basename -- "$input")


    existing_dimensions=""
    existing_filename=""

    for file in "$output_dir"/*.{jpg,png}; do
        if [ -f "$file" ]; then
            existing_dimensions=$(identify -format "%w %h" "$file")
            existing_filename=$(basename -- "$file")

            if [ "$existing_dimensions" = "$dimensions" ] && [ "$existing_filename" = "$filename" ]; then
                echo "$filename already exists in $(basename -- "$output_dir")"
                return
            fi
        fi
    done

    if ! [ -f "$output_dir/$filename" ]; then
        if convert "$input" -resize "$dimensions" -quality 80 "$output_dir/$filename"; then
            printf "%-60s | %-60s\n" "Resized & Moved $filename to $(basename -- "$output_dir")" "Destination: $output_dir/$filename" >> "$log_file"
        else
            echo "Error: Resize operation failed for $filename"
            return 1
        fi
    else
        echo "$filename already exists in $(basename -- "$output_dir")"
        mv "$input" "$output_dir/$filename"
        printf "%-60s | %-60s\n" "Moved $filename to $(basename -- "$output_dir")" "Destination: $output_dir/$filename" >> "$log_file"
    fi
}

# Check if source directory is empty
if [ -z "$(ls -A $source_dir)" ]; then
    echo "Nothing is in the source directory."
fi

for file in "$source_dir"/*.{jpg,png}; do

    if [ -f "$file" ]; then
        dimensions=$(identify -format "%w %h" "$file")

        if echo "$dimensions" | awk '{exit !($1>=1260 && $1<=3000 && $2>=1260 && $2<=3000)}'; then
            move_if_same_dimensions_and_resize_if_not "$file" "$destination_dir1" "2240x1260"
        elif echo "$dimensions" | awk '{exit !($1>=316 && $1<=1000 && $2>=316 && $2<=743)}'; then
            move_if_same_dimensions_and_resize_if_not "$file" "$destination_dir2" "1000x743"
        elif echo "$dimensions" | awk '{exit !($1>=210 && $1<=310 && $2>=210 && $2<=310)}'; then
            move_if_same_dimensions_and_resize_if_not "$file" "$destination_dir3" "200x200"
        elif echo "$dimensions" | awk '{exit !($1>=130 && $1<=199 && $2>=130 && $2<=199)}'; then
            move_if_same_dimensions_and_resize_if_not "$file" "$destination_dir4" "120x120"
        else
            echo "Moving $file to unmatched directory"
            mv "$file" "$unmatched_dir/"
            printf "%-60s | %-60s\n" "Moved $file to unmatched directory" "Destination: $unmatched_dir/$(basename -- "$file")" >> "$log_file"
        fi
    fi
done
