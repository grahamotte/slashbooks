# == Schema Information
#
# Table name: books
#
#  id         :bigint           not null, primary key
#  author     :string           not null
#  title      :string           not null
#  digest     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Book < ApplicationRecord
  has_one_attached :epub

  has_many :texts, -> { where(media_type: Constants::HTML_LIKE_TYPES).order(:pos) }, dependent: :destroy, class_name: "BookPart", inverse_of: :book
  has_many :images, -> { where(media_type: Constants::IMAGE_LIKE_TYPES).order(:pos) }, dependent: :destroy, class_name: "BookPart", inverse_of: :book

  validates :author, presence: true
  validates :title, presence: true
  validates :digest, presence: true

  def full_title
    "#{title} by #{author}"
  end

  def total_words
    texts.sum(&:word_count)
  end

  def window(pos, target: 1000)
    c = 0

    end_pos = texts
      .where('pos > ?', pos)
      .find { |p| (c += p.word_count) > target }
      .then { |p| p&.pos || texts.last.pos }

    texts.where(pos: (pos...end_pos))
  end
end
