# == Schema Information
#
# Table name: subscriptions
#
#  id      :bigint           not null, primary key
#  email   :string           not null
#  book_id :integer          not null
#  pos     :integer          default(0), not null
#

class Subscription < ApplicationRecord
  belongs_to :book

  before_validation do
    self.pos ||= 0
    self.uuid ||= SecureRandom.uuid
  end

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :pos, numericality: { greater_than_or_equal_to: 0 }
end
