import sys

def replicate_html(input_filename):
    # Read HTML file content with UTF-8 encoding
    with open(input_filename, 'r', encoding='utf-8') as file:
        html_content = file.read()

    while True:
        # Ask the user for the number of replications
        replicate_count = input("Enter the number of HTML replications: ")
        try:
            replicate_count = int(replicate_count)
            confirmation = input(f"Are you sure you want to replicate {replicate_count} times? (yes/no): ")
            if confirmation.lower() == 'yes':
                break  # Break out of the loop if confirmed
        except ValueError:
            print("Please enter a valid number.")

    for i in range(1, replicate_count + 1):
        name = input(f"Enter the name for replicate {i}: ")
        replicated_html = html_content.replace('</body>', f'<h1>{name}</h1></body>')

        # Write replicated content to a new HTML file
        with open(f'{name}.html', 'w', encoding='utf-8') as file:
            file.write(replicated_html)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python replicate_html.py <input_filename>")
        sys.exit(1)

    input_filename = sys.argv[1]
    replicate_html(input_filename)
