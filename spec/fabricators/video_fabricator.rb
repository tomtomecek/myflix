Fabricator(:video) do
  title { Faker::Lorem.words(2).join(' ') }
  description { Faker::Lorem.words(Array(30..40).sample).join(" ") }
  small_cover { |attrs| "#{attrs[:title]}.jpg" }
  large_cover { |attrs| "#{attrs[:title]}_large.jpg" }
  video_url { Faker::Internet.url }
end