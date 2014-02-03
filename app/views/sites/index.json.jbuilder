json.array!(@sites) do |site|
  json.extract! site, :id, :file_path, :title
  json.url site_url(site, format: :json)
end
