// Function to format the date
function formatDate(date) {
  const options = { year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', timeZoneName: 'short' };
  return new Date(date).toLocaleDateString('en-US', options);
}

// Set the last modified date
const lastModifiedDate = document.lastModified;

// Display the last modified date
const lastModifiedDateElement = document.getElementById('last-modified-date');
lastModifiedDateElement.textContent = 'Last updated: ' + formatDate(lastModifiedDate);
