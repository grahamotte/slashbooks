class BaseModels < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :author, null: false
      t.string :title, null: false
      t.string :digest, null: false
    end

    create_table :book_parts do |t|
      t.integer :book_id, null: false
      t.integer :pos, null: false, default: 0
      t.string :label, null: false
      t.string :media_type, null: false
      t.string :href
      t.binary :content, null: false
    end

    create_table :subscriptions do |t|
      t.string :uuid, null: false
      t.string :email, null: false
      t.integer :book_id, null: false
      t.integer :pos, null: false, default: 0
    end
  end
end
