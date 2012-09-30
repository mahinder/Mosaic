function remove_fields(link) {
 $(link).parent(".fields").find("input[type=hidden]").attr("value" , "1");
 $(link).parent(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

$(document).ready(function(){
	$('.albumDetails').dataTable();
});
