Fabricator(:user) do
  fullname { Faker::Name.name }
  email { |attrs| "#{attrs[:fullname].parameterize}@example.com" }
  password { "password" }
end