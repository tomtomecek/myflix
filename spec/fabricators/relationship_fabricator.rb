Fabricator(:relationship) do
  follower(fabricator: :user)
  followed(fabricator: :user)
end