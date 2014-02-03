json.array!(@extmaps) do |extmap|
  json.extract! extmap, :id, :suffix, :lang, :noindex, :noedit, :category
  json.url extmap_url(extmap, format: :json)
end
