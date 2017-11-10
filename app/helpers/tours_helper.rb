module ToursHelper
  def tab_link text, current_tab, tab, is_default = false
    default = current_tab.nil? && is_default
    link_to text, "##{tab}",
      data: {toggle: "tab"},
      class: "nav-link #{current_tab == tab || default ? 'active' : ''}",
      role: "tab"
  end

  def tab current_tab, name, is_default = false
    default = current_tab.nil? && is_default
    content_tag :div,
      class: "tab-pane #{current_tab == name || default ? 'show active' : ''}",
      id: name, role: "tabpanel" do
      yield
    end
  end
end
