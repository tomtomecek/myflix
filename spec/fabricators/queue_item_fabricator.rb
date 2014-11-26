Fabricator(:queue_item) do
  position { sequence(:position) { |i| i } }
  user
  video
end