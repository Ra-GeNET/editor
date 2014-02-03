json.array!(@langs) do |lang|
  json.extract! lang, :id, :title, :code
  json.url lang_url(lang, format: :json)
end
