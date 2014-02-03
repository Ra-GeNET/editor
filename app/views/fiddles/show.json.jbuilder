json.extract! @fiddle, :id, :title, :code, :langcode, :skin, :fontsize, :lineheight, :created_at, :updated_at, :deleted_at, :noindex, :preview_url, :category
json.url fiddle_url(@fiddle, format: :json)
