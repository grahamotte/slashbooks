# == Schema Information
#
# Table name: subscriptions
#
#  id                :bigint           not null, primary key
#  uuid              :string           not null
#  email             :string           not null
#  book_id           :integer          not null
#  pos               :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  words_per_message :integer          default(1000), not null
#

class Subscription < ApplicationRecord
  belongs_to :book

  before_validation do
    self.uuid ||= SecureRandom.uuid
  end

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :pos, numericality: { greater_than_or_equal_to: 0 }
  validates :words_per_message, numericality: { greater_than_or_equal_to: 0 }

  def done?
    current_window.last.pos == pos
  end

  def current_part_count
    pos
  end

  def parts_count
    book.texts.count
  end

  def current_window
    book.window(pos, target: words_per_message)
  end

  def messages_so_far_count
    (book.texts.where(pos: (0..current_window.last.pos)).sum(&:word_count).to_f / words_per_message).ceil
  end

  def messages_total_count
    (book.total_words.to_f / words_per_message).ceil
  end
end
