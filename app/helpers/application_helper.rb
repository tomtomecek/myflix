module ApplicationHelper
  def rating_options
    Array(1..5).reverse.map { |n| [pluralize(n, "Star"), n] }
  end

  def display_invited_email_or_nothing
    params[:invitation_email] ? params[:invitation_email] : ''
  end

  def average_ratings
    (10..50).map { |num| num / 10.0 }
  end

  def gravatar_for(user)
    image_tag("http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}?s=40")
  end
end
