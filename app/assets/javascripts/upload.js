var upload_progress = function() {
  if ($('.upload-progress').length) {
    $.get(window.location.pathname, function(data, textStatus, jqxhr) {
      if(/Importing/.test(data)) {
        console.log("Matched 'Importing'");
        $("#status").html(data);
        setTimeout(upload_progress, 2000);
      } else {
        console.log("Unmatched");
        window.location.reload(true);
      }
    });
  }
};
$(document).ready(upload_progress);
