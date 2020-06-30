function UserAreaSelect() {
  var self = this;

  self.initialize = function() {

    this.primary_area_select = $('.area-select').first();

    if (!this.primary_area_select) {
      return;
    }

    this.options = this.primary_area_select.find('optgroup');
    this.secondary_area_selects = $('.area-select').toArray();
    this.secondary_area_selects.shift();
    this.current_area_type = this.get_current_area_type();

    this.primary_area_select.on('change', this.update_secondary_areas.bind(this));
    this.update_secondary_areas();
  }

  self.get_current_area_type = function() {
    var selected_optgroup = this.primary_area_select.find('option:selected');
    return selected_optgroup.parent()[0].label;
  }

  self.update_secondary_areas = function(_evt = null) {
    var area_type = this.get_current_area_type();

    if (area_type === this.current_area_type) {
      return;
    }

    this.current_area_type = area_type;
    var new_options = this.options.toArray().find(function(o) { return o.label === area_type });

    this.secondary_area_selects.map(function(s){
      s = $(s);
      s.html(null);
      $("<option value>Select an area</option>").appendTo(s);
      $("<option value></option>").appendTo(s);
      $(new_options).clone().appendTo(s);
      s.val(null);
    });
  }
}

$(function() {
  var user_area_select = new UserAreaSelect();
  user_area_select.initialize();
})
