Fabricator(:relationship) do
  follower(fabricator: :user)
  leader(fabricator: :user)
end
