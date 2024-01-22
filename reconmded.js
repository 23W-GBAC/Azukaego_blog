async function fetchHomepageUrls() {
  const response = await fetch('group_url.json');
  const data = await response.json();
  return data.map(entry => entry.homepageUrl).filter(url => url); // Filter out empty URLs
}

function getRandomPostURL(homepageUrls) {
  const randomIndex = Math.floor(Math.random() * homepageUrls.length);
  return homepageUrls[randomIndex];
}

function openInNewTab(url) {
  window.open(url, '_blank');
}

async function displayRandomPost() {
  const homepageUrls = await fetchHomepageUrls();
  const randomPostURL = getRandomPostURL(homepageUrls);
  const postContainer = document.querySelector('.reconmend');

  if (window.innerWidth < 1024) {
    // Mobile styles
    const containerHeight = window.innerHeight * 0.22; // Adjust the multiplier as needed
    const iframeHeight = containerHeight - 40; // Adjust the padding/margin as needed
    postContainer.innerHTML = `
      <div style="position: relative; width: 100%; height: ${containerHeight}px; overflow: hidden;">
        <iframe src="${randomPostURL}" width="100%" height="${iframeHeight}px" style="position: absolute; top: 0; left: 0; transform: scale(1.0); transform-origin: 0 0;"></iframe>
        <div class="recommended-text" style="text-align: center; margin-top: ${iframeHeight}px; font-family: 'Montserrat'; color: white;">
          <h3>Recommended Post</h3>
        </div>
        <button style="position: absolute; top: 10px; left: 10px; padding: 2px; height: 3vh; background-color: #3498db; color: #fff; border: none; cursor: pointer;" onclick="openInNewTab('${randomPostURL}')">Open in New Tab</button>
      </div>`;
  } else {
    // Desktop styles
    postContainer.innerHTML = `
      <div style="position: relative; width: 100%; height: 60vh; border-radius: 20px; padding-bottom: 75%; overflow: hidden;">
        <iframe src="${randomPostURL}" width="100%" height="100%" style="position: absolute; top: 0; left: 0; transform: scale(1.0); transform-origin: 0 0;"></iframe>
        <button style="position: absolute; bottom: 19px; right: 23px; height: 6vh; padding: 8px; background-color: rgb(27 127 204); color: #fff; border: none; font-family: 'Montserrat'; cursor: pointer;" onclick="openInNewTab('${randomPostURL}')">Open in New Tab</button>
      </div>
      <div class="recommended-text" style="text-align: center; margin-top: 10px; font-family: 'Montserrat'; color: white; font-size: x-large;">
        <h3>Recommended Post</h3>
      </div>`;
  }
}


window.onload = displayRandomPost;
