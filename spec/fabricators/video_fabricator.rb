Fabricator(:video) do
  title { Faker::Lorem.word }
  description { Faker::Lorem.words(5).join(" ") }
  category
end