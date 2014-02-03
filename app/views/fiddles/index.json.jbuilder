json.array!(@fiddles) do |fiddle|
  json.extract! fiddle, :id, :title, :lang, :updated_at, :deleted_at, :noindex, :preview_url, :category
  json.url fiddle_url(fiddle, format: :json)
end
