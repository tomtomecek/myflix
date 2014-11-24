module ApplicationHelper

  def rating_options
    arr = []
    Array(1..5).each do |n|
      arr << [pluralize(n, "Star"), n]
    end
    arr.reverse
  end
end
