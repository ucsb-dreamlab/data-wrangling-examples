# YouTube in a Qualtrics Survey

This example demonstrates how to embed a YouTube video in a Qualtrics Survey and check
that the video has completed before advancing in the survey.

## Steps

1. Create a new Qualtrics survey with at least three block: for the pre-video
   questions, for the video, and for the post-video questions.
2. In the middle block, add a "Text/Graphic" question and use the "Rich Content
   Editor" to add the YouTube embed html. The `iframe`'s `id` attribute needs 
   to be set and the `src` url should include `enablejsapi=1`.

```html
<p>Please watch the video below. Click the next button when the video finishes.</p>
<iframe width="560" src="https://www.youtube.com/embed/CHANGEME?enablejsapi=1" id="watchme" height="315"></iframe>
```

3. Add the following Javascript to the question. The script disables the 'Next' button
   and re-enables the button when the youtube video has finished playing.

```js
Qualtrics.SurveyEngine.addOnReady(function(){
  var qual = this
  qual.disableNextButton();
	
	// Load the YouTube API script
  var tag = document.createElement('script');
	tag.src = 'https://www.youtube.com/iframe_api';
  var firstScriptTag = document.getElementsByTagName('script')[0];
	firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
  
	// add event listener to enable next button when
  // the video ends
  window.onYouTubeIframeAPIReady = function() {
	  new YT.Player('watchme', {
      events: {
		    'onStateChange': function(event) {
			    if (event.data == YT.PlayerState.ENDED) {
					  qual.enableNextButton();
				  }
			  }
		  }
	  });
  };
});
``
