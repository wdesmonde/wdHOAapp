module ApplicationHelper

  # where the logo is
  def logo
    logo = image_tag("WWMastHead.jpg", :alt => "WWCA Requests",
      :class => "round")
  end

  # Return a title on a per-page basis
  def title
    base_title = "WWCA Requests"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end  
end
