var upload_progress = function() {
  if ($('.upload-progress').length) {
    var timerId = setInterval(function(){
      $.get(window.location.pathname, function(data, textStatus, jqxhr) {
        console.log(textStatus);
        if(textStatus === "200") {
          $("#status").html(data);
        } else {
          clearInterval(timerId);
          window.location.reload(true);
        }
      });
      /*
      $.getScript(window.location.pathname, function(data, textStatus, jqxhr) {
        console.log('Status info updated.');
      });
      */
    },2000);
  }
};

// $(document).ready(upload_progress);
$(document).on("turbolinks:load", upload_progress);
