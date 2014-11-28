Fabricator(:queue_item) do
  position { sequence(:position) { |i| i + 1 } }
  video  
end