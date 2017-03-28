var upload_progress = function() {
  if ($('.upload-progress').length) {
    setInterval(function(){
      $.getScript(window.location.pathname, function(data, textStatus, jqxhr) {
        console.log('Status info updated.');
      });
    },2000);
  }
};

// $(document).ready(upload_progress);
$(document).on("turbolinks:load", upload_progress);
