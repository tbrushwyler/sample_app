module ApplicationHelper
  def full_title(page_title)
	base_title = "Ruby on Rails Tutorial Sample App"
	if page_title.empty?
	  base_title
	else
	  "#{base_title} | #{page_title}"
	end
  end

  # http://railscasts.com/episodes/197-nested-model-form-part-2
  def button_to_add_fields(name, f, association)
  	new_object = f.object.class.reflect_on_association(association).klass.new
  	fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
  	  render("shared/" + association.to_s.singularize + "_fields", f: builder)
  	end
  	button_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", class: "answer")
  end
end