json.success true
json.message 'Sector deleted successfully'
json.data do
  json.sector do
    json.partial! 'api/v1/sectors/shared/sector', sector: @sector
  end
end

