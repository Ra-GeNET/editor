json.array!(@skins) do |skin|
  json.extract! skin, :id, :title, :code
  json.url skin_url(skin, format: :json)
end
