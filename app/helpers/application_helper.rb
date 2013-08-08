module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.upcase
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    if season
      if team_id
        link_to title, {sort: column, direction: direction, season: season, team_id: team_id}, {:class => css_class}
      else
        link_to title, {sort: column, direction: direction, season: season}, {:class => css_class}
      end
    else
      link_to title, {sort: column, direction: direction}, {:class => css_class}
    end
  end

  def season_url_builder(params, season)
    if params[:sort]
      if params[:team_id]
        return {sort: params[:sort], direction: params[:direction],
                season: season, team_id: params[:team_id]}
      else
        return {sort: params[:sort], direction: params[:direction], season: season}
      end
    else
      if params[:team_id]
        return {season: season, team_id: params[:team_id]}
      else
        return {season: season}
      end
    end
  end
end
