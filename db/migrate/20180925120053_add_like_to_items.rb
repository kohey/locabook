class AddLikeToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :like, :boolean, default: false
  end
end
