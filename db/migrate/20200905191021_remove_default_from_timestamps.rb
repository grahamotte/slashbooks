class RemoveDefaultFromTimestamps < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:subscriptions, :created_at, from: Time.now, to: nil)
    change_column_default(:subscriptions, :updated_at, from: Time.now, to: nil)

    change_column_default(:books, :created_at, from: Time.now, to: nil)
    change_column_default(:books, :updated_at, from: Time.now, to: nil)

    change_column_default(:book_parts, :created_at, from: Time.now, to: nil)
    change_column_default(:book_parts, :updated_at, from: Time.now, to: nil)
  end
end
