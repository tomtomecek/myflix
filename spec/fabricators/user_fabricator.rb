Fabricator(:user) do
  fullname { Faker::Name.name }
  email { |attrs| "#{attrs[:fullname].parameterize}@example.com" }
  password "password"
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end