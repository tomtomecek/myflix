Fabricator(:review) do
  rating { 5 }
  body { Faker::Lorem.words(10).join(" ") }
  user
  video
end
