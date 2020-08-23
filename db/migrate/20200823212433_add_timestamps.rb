class AddTimestamps < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :books, default: Time.zone.now
    add_timestamps :book_parts, default: Time.zone.now
    add_timestamps :subscriptions, default: Time.zone.now
  end
end
