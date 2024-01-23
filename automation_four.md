
___

## WEEK FOUR (Automating reconmended random post)

___

When I started using GitHub about 8months ago, I didn't know you could host your webpage without any cost. I found out during the general business class. As I stated in the first week of automation about how I had to strip my blog layout for the design I had in mind and one of the designs was to have a separate section where I could do advertisement depending on the article, be it health, technology or fashion. Aside from the fact I am into  designing stuff, be it for interface. I also in my free time, design, make and customize clothes for plus-size women like myself. At first, I thought I could only blog surrounding my content to just technology and healthcare and when I found out, it could be anything.

I started building my blog to accommodate Fashion content also, I am an expert with 2D software like Valentina, used in patterning clothes, and good on hand without the software. I like to share more content about it with my current content. Unfortunately designing and making clothes can be time-consuming, especially with recording the process and editing videos but that doesn't mean I shouldn't build my blog to accommodate it and post in my free time, I mean hosting it on GitHub is free, and saves me money. 

So this is where my last automation comes in. It was the hardest because I was overthinking it. You know when you go to a webpage and you are trying to read an article, and there are these annoying pop-up ads, that have to force us or automatically just open to another window tab. I hate it and would not want to do that to whoever visits my blog to read, learn or just to see content or articles, and that was why I created a section for it and it is the readers' choice to choose if they are interested in whatever is in that section.

I like some of my colleague's blog posts and would also like to advertise their post on that section too, the ones with the paws and claws, food, mental health and a few others and I thought about how would i share these posts live on my page that links back to them if my blog visitors wants to see more of that. I wanted to do a script that a screenshot of their blog and pop-ups as recommended post, the way an advertisement would be without having to bug blog visitors but then again a screenshot doesn't reflect if they made any changes in their blog. The fashion target article, would have a fashion target advertisement, the technology and health article would have health and technology target advertisment, the only downside is that most businesses I know, do their business on social media like Instagram, WhatsApp, and Twitter and it is difficult to run advertisements for businesses that do their business on WhatsApp and you might wonder why? would be revealed at the end of the automation. This automation is a two-in-one automation. 

In this case, I would be using my colleague's homepage URL, I recently did feedback on a colleague on their repo and I had to be cautious because it took a lot of trust to “take care of their repository” and we were both unskilled with merging and in a case where I want to recommend 50 blogposts, will I have to gain the trust of 50 people to let me extract direct information. I did one feedback on just one of my colleague's repositories and was sweating not to mess it up, 50 or 100 people trust to gain, too much pressure. 

So I decided to use their Homepage URL instead. I tested it with two URLs and it worked but with 50 people, I could not do that manually then I remembered in one of the classes the professor extracted all our repository API information to a JSON file, and that's when I summoned chatgpt. I asked if I were able to get a whole bunch of URLs in a JSON file, can we randomly select a blog post to pop up as a recommended post in my HTML from that JSON file using javascript? It said yes, and honestly to my surprise, it worked the first time. First, to get the entire class group URL, I had to download Github’s CLI again because my Ubuntu kept crashing, so I had to do it from the VS code terminal and authorise login, to be able to extract the information I needed, so yes it can be done from VS code and didn't cause any issues. Let’s roll out the pseudo-code. 

PSEUDOCODE:
Step 1- Create a shell script that extracts all the  group homepage URLs and sends them to a JSON file
Step 2- The code should be able to grab the URL and the ID section where it is supposed to pop up in the HTML layout.
Step 3- Ask chatgpt, we don't know much about javascript, just little enough to know where an error occurs or where it is coming from. Let’s not get ahead of ourselves now.

```json

#!/bin/bash

gh repo list 23W-GBAC -L 30 --json homepageUrl >> group_url.json

```
This command uses Github CLI to list repositories in the 23W-GBAC group repository and fetches information about the latest 30 repositories in this case, I experimented with 30 repositories from the GitHub organization 23W-GBAC, specifically requesting the homepage URL for each repository, and then appends this information in JSON format to a file named group_url.json I created to store the list of URLs

Then we move on to the Javascript:

```json

async function fetchHomepageUrls() {
  const response = await fetch('group_url.json');
  const data = await response.json();
  return data.map(entry => entry.homepageUrl).filter(url => url); // Filter out empty URLs
}

```
This code uses the fetch function to get data using HTTP request to the  group_url.json., and wait for a response, after receiving the response, it extracts the JSON content, Once the JSON data is obtained, the function maps over each entry in the data array and extracts the homepage URL property. Then, it filters out any empty URLs (falsy), closing the block function.

```json

function getRandomPostURL(homepageUrls) {
  const randomIndex = Math.floor(Math.random() * homepageUrls.length);
  return homepageUrls[randomIndex];
}

function openInNewTab(url) {
  window.open(url, '_blank');
}

```

These functions get random posts by taking an array of the homepage URLs of the group repository as its parameter and using math.random() to generate a random floating point number between 0 and 1 and using math.floor() to bring it down to the nearest whole number, creating random integer between 0 and the length of homepage URLs. The random index retrieves the URL at the randomly generated index, selecting a random URL from the array and the second function is to be able to open the URL in a new tab when called..In summary, the function gets a random post URL which is already in its name and selects a URL to pop up in the HTML layout.

```json

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

````

The display random post function, gets a random post, assigning a random URL as stated earlier and the document. query selector selects an element with a class name “recommend”, which is the element class in my HTML blog post layout under the post container div. The div display for the iframe gives readers a window into what this recommended blog post or blog looks like, more like window shopping when you go to the mall. This was why I said it would be hard to do business advertisements that use WhatsApp which uses phone numbers and not URLs, this is the only limitation. Whatsapp has a barcode but does it give you a window to anything, you literally have to scan the QR code to check the media shop of the business, but with the windows to the URLs, you see what you are getting. The if and else are, so that the iframe can be responsive to both desktop and mobile views, the selected URL is embedded in an iframe, and a button is provided to open the URL in a new tab. Window.onload ensures random post runs when the page loads finish. See sample of random post:

Random post 1:

![random post one](original_images/reconmend_one.png)

Random post 2:

![random post two](original_images/reconmend_two.png)

Random post 3:

![random post three](original_images/reconmend_three.png)

___

### [WEEK ONE](automation_one.md) | [WEEK TWO](automation_two.md) | [WEEK THREE](automation_three.md)