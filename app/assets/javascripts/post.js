function add_fields(button, association, content) {
	var new_id = new Date().getTime();
	var regex = new RegExp("new_" + association, "g");
	
	$(button).before(content.replace(regex, new_id));
	var num_answers = $(button).parent().children(".answer").length;
	$(button).parent().children(".answer").get(num_answers - 2).focus();

	if (num_answers == 5) // only allow 5 answers
		$(button).remove();
}