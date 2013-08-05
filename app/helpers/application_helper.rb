module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.upcase
    column = "id" if column == "name"
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    puts css_class
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    title = "TEAM" if title == "TEAM_ABBREV"
    title = "+/-" if title == "PLUS_MINUS"
    title = "S%" if title == "SHOT_PERC"
    title = "FO%" if title == "FO_PERC"
    link_to title, {sort: column, direction: direction}, {:class => css_class}
  end
end
