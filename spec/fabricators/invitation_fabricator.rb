Fabricator(:invitation) do
  recipient_name { Faker::Name.name }
  recipient_email { |attrs| "#{attrs[:recipient_name].parameterize}@example.com" }
end