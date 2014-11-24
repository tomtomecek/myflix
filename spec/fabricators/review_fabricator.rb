Fabricator(:review) do
  rating { Array(1..5).sample }
  body { Faker::Lorem.words(Array(100..120).sample).join(" ") }
  user
  video
end
