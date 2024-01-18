Qualtrics.SurveyEngine.addOnReady(function() {
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
