class AddPriorityToExtmap < ActiveRecord::Migration
  def change
    add_column :extmaps, :priority, :integer
  end
end
