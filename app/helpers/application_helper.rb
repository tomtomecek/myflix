module ApplicationHelper
  def rating_options
    Array(1..5).reverse.map { |n| [pluralize(n, "Star"), n] }
  end

  def display_invited_email_or_nothing
    params[:invitation_email] ? params[:invitation_email] : ''
  end
end
