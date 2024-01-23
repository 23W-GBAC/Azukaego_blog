
___

## WEEK THREE  (Replicating html pages using python script)

___

After doing the Python script for logging all my blog images in my repository except the image source directory for resizing images. While experimenting with different designs, I was on my second HTML and second stylesheet and realised it was becoming and decided why not write a Python script to replicate your HTML for you, it is tedious to have to copy and paste and rename and the constant typing, so let's roll out the pseudocode!

PSEUDOCODE:
One of the many things I see as a good use of being an overthinker is that it helps me think of many flags regarding codes.

Step 1: At first I was going to hardcode it, copy the sample HTML and store it in a string variable, with the triple quote, python can take a long block of string but then again it takes away the versatility of the code, so we use reading from a file and writing into another file as I did before.

Step 2: Yes, I have become obsessed with the prompt, why don’t we prompt replicating multiply HTML, say 5 6 or 8:

Step 3: Prompt again if the said number of HTML we want to replicate is the number we actually want to replicate, i might change my mind on the number of HTML I want sometimes and to save us the time of going to renaming those files at were they were replicated to, why don't we have that prompt iterate naming the said numbers of files we replicate and name them. I mean what if there is an alien invasion and I need to write one more blog post before I get beamed up, who has time for copying and pasting and renaming? I already made the standard HTML I want to use for all my blog posts down to the blockquote.

```json

Import sys
def replicate_html(input_filename):
   # Read HTML file content with UTF-8 encoding
    with open(input_filename, 'r', encoding='utf-8') as file:
        html_content = file.read()
```
Defining function for replicating my HTML and in this case it is taking one argument which is input filename and the filename is the name of my standard sample HTML, when I run it from the terminal. It reads from the HTML standard sample file, a universal language. The first time I ran this code, it gave an encoding error and I checked with chatgpt and was told I would keep getting errors if I didn't include the encoding (utf-8). So basically, it is like opening a website that is in a language or has multiple languages on it that you are not native to and you forgot to turn on Google Translate the page automatically, the website is confusing to you, until you click on auto Google translate to help translate to the language you understand so you can read what is on the website. The website is the HTML file sample, and what you are reading on the website is the content of what is in the HTML file sample and the utf-8 is what language you want to read it in. import sys helps with that process more like a tool.

```json

   while True:
        # Ask the user for the number of HTML replications
        replicate_count = input("Enter the number of HTML replications: ")
        try:
            replicate_count = int(replicate_count)
            confirmation = input(f"Are you sure you want to replicate {replicate_count} times? (yes/no): ")
            if confirmation.lower() == 'yes':
                break  # Break out of the loop if confirmed
        except ValueError:
            print("Please enter a valid number.")
```

This block of code, asks me how many HTML pages I want to replicate and after I input the number of HTML pages I want to replicate and ask again for confirmation, if I say yes, it breaks out of the loop, if I say no, it goes back to ask how many HTML pages I want to replicate.

```json

   for i in range(1, replicate_count + 1):
        # Ask for a name for each replication
        name = input(f"Enter the name for replicate {i}: ")
                # Customize each replication by adding a heading
        replicated_html = html_content.replace('</body>', f'<h1>{name}</h1></body>')
  # Write the customized content to a new HTML file
        with open(f'{name}.html', 'w', encoding='utf-8') as file:
            file.write(replicated_html)

```
It iterates the number of HTML pages I choose to replicate and gives a prompt to name those replicate HTML pages and their personalised fill name. For example, after choosing to replicate 2 HTML pages, it asks me what to name the file, and put a heading into the file with the name that was used for naming the file.

```json

      if __name__ == "__main__":
	    if len(sys.argv) != 2:
        print("Usage: python replicate_html.py <input_filename>")
        sys.exit(1)
        

```
The usage in this block was suggested to me by chatgpt, so when I don't input the number of arguments or argument, it reminds me how to do it properly and exit running the code any further

```json

     input_filename = sys.argv[1]
    replicate_html(input_filename)

````
It takes the input filename from the command line argument and calls the replicate_html function, passing the input file name as an argument…

To run the script: 

```json

python3.12 replicate_html.py mary-journey.html

```

Mary-journey.html is the HTML standard page I use for the remaining of my blog post layout, they all share the same stylesheet and if there is a page that needs major change, I can always add a new ID and still use the same shared stylesheet and hope to keep blogging in the future. Surprisingly this is the first automation that didn’t have issues. The only issue I encountered was on another code for time-stamping my blogpost using JavaScript and it was unsuccessful, I was only able to do a last modified timestamp and just wrote when the blog post was created manually but if I did any modification or changes in the blog post, it will reflect on the HTML page section for the time-stamp.

__

### [WEEK ONE](automation_one.md)  |  [WEEK TWO](automation_two.md)  | [WEEK FOUR](automation_four.md)