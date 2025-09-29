json.success true
json.message 'Perk updated successfully'
json.data do
  json.perk do
    json.partial! 'api/v1/perks/shared/perk', perk: @perk
  end
end




