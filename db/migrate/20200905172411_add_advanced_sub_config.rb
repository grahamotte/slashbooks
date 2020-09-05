class AddAdvancedSubConfig < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :words_per_message, :integer, default: 1000, null: false
  end
end
