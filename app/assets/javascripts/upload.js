var upload_progress = function() {
  if ($('.upload-progress').length) {
    $.get(window.location.pathname, function(data, textStatus, jqxhr) {
      if(/Importing/.test(data)) {
        $("#status").html(data);
        setTimeout(upload_progress, 2000);
      } else {
        window.location.reload(true);
      }
    });
  }
};
$(document).ready(upload_progress);
