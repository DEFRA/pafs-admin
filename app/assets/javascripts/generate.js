var generation_progress = function() {
  if ($('.generation-progress').length) {
    $.get(window.location.pathname, function(data, textStatus, jqxhr) {
      if(/status pending/.test(data)) {
        $("#status").html(data);
        setTimeout(generation_progress, 2000);
      } else {
        window.location.reload(true);
      }
    });
  }
};
$(document).ready(generation_progress);

