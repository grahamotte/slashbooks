# == Schema Information
#
# Table name: book_parts
#
#  id         :bigint           not null, primary key
#  book_id    :integer          not null
#  pos        :integer          default(0), not null
#  label      :string           not null
#  media_type :string           not null
#  href       :string
#  content    :binary           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BookPart < ApplicationRecord
  belongs_to :book

  validates :pos, numericality: { greater_than_or_equal_to: 0 }
  validates :label, presence: true
  validates :media_type, presence: true, inclusion: { in: Constants::MEDIA_TYPES }
  validates :content, presence: true

  def word_count
    return 0 unless Constants::HTML_LIKE_TYPES.include?(media_type)
    Nokogiri::HTML(content).text.split.length
  end
end
