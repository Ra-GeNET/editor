class AddContentTypeToLang < ActiveRecord::Migration
  def change
    add_column :langs, :content_type, :string
  end
end
