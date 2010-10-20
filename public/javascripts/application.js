function remove_fields(link) {
  destroy_link = $(link).prev("input[type=hidden]");
  destroy_link.val("1");
  destroy_link.prevAll(".input-field").remove();
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  //$(link).parent().before(content.replace(regexp, new_id));
  $(link).before(content.replace(regexp, new_id));
}

