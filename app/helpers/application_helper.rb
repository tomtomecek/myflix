module ApplicationHelper

  def rating_options
    arr = []
    Array(1..5).each do |n|
      arr << [pluralize(n, "Star"), n]
    end
    arr.reverse
  end

  def display_invited_email_or_nothing
    params[:invitation_email] ? params[:invitation_email] : ''
  end

  def categories_select
    Category.all.map {|category| [category.name, category.id]}
  end
end
