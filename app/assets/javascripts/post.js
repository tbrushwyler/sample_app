$(function() {
	$(document).on('click', "input[type='button'].answer", function(e) {
		var index = $(this).index("input.answer");
		
		if (index <= 2) {
			$(this).after("<input type='button' class='answer' value='+' />");
		}
		
		$(this).replaceWith("<input type='text' class='answer' />");
		$("input.answer").get(index).focus();

		e.preventDefault();
	});
});