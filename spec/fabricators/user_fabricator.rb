Fabricator(:user) do
  email { Faker::Internet.email }
  password { "password" }
  fullname { Faker::Name.name }
end