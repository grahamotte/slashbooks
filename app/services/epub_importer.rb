class EpubImporter
  KEEP_TAGS = %w[
    i span p h1 h2 h3 h4 h5 h6 img div
  ]

  attr_accessor :file, :parsed, :pos, :digest

  def initialize(file)
    @file = file
    @digest = Digest::SHA512.hexdigest(epub_file.read)
    @parsed = GEPUB::Book.parse(epub_file)
    @pos = 0
  end

  def self.call(file)
    new(file).call
  end

  def call
    existing = Book.find_by(digest: digest)
    return existing if existing.present?

    ActiveRecord::Base.transaction do
      book.epub.attach(io: epub_file, filename: "#{book.title} - #{book.author}.epub")

      parsed.items.each do |key, item|
        next if item.blank?
        next if item.content.blank?

        case item.media_type
        when 'application/xhtml+xml', 'application/x-dtbncx+xml', 'application/vnd.adobe.page-template+xml'
          item
            .content
            .then { |x| Nokogiri::HTML(x) }
            .then { |x| slice_html(x) }
            .each { |x| create_part!(key, item.media_type, x) }
        when 'image/jpeg', 'image/png', 'image/jpg', 'image/gif'
          create_part!(key, item.media_type, item.content, href: item.href)
        when 'application/x-font-ttf', 'text/css'
          nil
        else
          # raise "failed import for #{item.media_type} #{item.content}"
        end
      end
    end

    book
  end

  private

  def epub_file
    @file.rewind
    @file
  end

  def slice_html(n)
    name = n&.name
    name = 'p' if name == 'div'

    if name == 'img'
      return <<~HTML
        <div style="text-align: center">
          <img
            src="#{n.attribute('src').value}"
            style="max-width:90%;max-height:20em;margin:0 auto;"
          />
        </div>
      HTML
    end

    return n.text.presence if name == 'text'

    if KEEP_TAGS.include?(name)
      inner = n.children.flat_map { |c| slice_html(c) }.compact.join(' ')
      return nil if inner.blank?
      return "<#{name}>#{inner}</#{name}>"
    end

    if n.children.present?
      return n.children.flat_map { |c| slice_html(c) }.compact
    end

    nil
  end

  def book
    @book ||= Book.create!(author: author, title: title, digest: digest)
  end

  def create_part!(label, type, content, href: nil)
    BookPart.create!(
      book: book,
      pos: pos,
      media_type: type,
      content: content,
      href: href,
      label: label,
    )
    @pos += 1
  end

  def author
    parsed.metadata.creator&.content || 'Unknown Author'
  end

  def title
    parsed.metadata.title&.content || 'Unknown Title'
  end
end
