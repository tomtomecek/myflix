Fabricator(:video) do
  title { Faker::Lorem.word }
  description { Faker::Lorem.words(Array(30..40).sample).join(" ") }
  small_cover_url { |attrs| "/tmp/#{attrs[:title]}.jpg" }
  large_cover_url { |attrs| "/tmp/#{attrs[:title]}_large.jpg" }
end