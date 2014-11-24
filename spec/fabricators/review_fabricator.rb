Fabricator(:review) do
  rating { "8" }
  body { Faker::Lorem.words(10).join(" ") }
  user
  video
end
