class CreateExtmaps < ActiveRecord::Migration
  def change
    create_table :extmaps do |t|
      t.string :suffix
      t.string :lang

      t.timestamps
    end
  end
end
