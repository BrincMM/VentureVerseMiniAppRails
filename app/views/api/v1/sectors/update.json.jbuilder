json.success true
json.message 'Sector updated successfully'
json.data do
  json.sector do
    json.partial! 'api/v1/sectors/shared/sector', sector: @sector
  end
end

