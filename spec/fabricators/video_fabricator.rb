Fabricator(:video) do
  title { Faker::Lorem.word }
  description { Faker::Lorem.words(Array(30..40).sample).join(" ") }
end