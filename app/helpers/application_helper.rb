module ApplicationHelper
  include SessionsHelper

  def nav_link link_text, link_path
    class_name = current_page?(link_path) ? "nav-item active" : "nav-item"

    content_tag :li, class: class_name do
      link_to link_text, link_path, class: "nav-link"
    end
  end

  def full_title page_title = nil
    base_title = t "layouts.application.base_title"

    if page_title.blank?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def link_to_remove_fields name, f
    f.hidden_field(:_destroy) + content_tag(:a, name, class: "btn btn-danger text-light btn-remove")
  end

  def link_to_add_fields name, f, association
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for association, new_object, child_index: "new_#{association}" do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    content_tag :a, name, class: "btn btn-dark text-light btn-add-more",
      data: {association: association.to_s, content: fields}
  end

  def category_roots
    Category.roots
  end
end
