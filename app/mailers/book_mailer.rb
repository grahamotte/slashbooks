class BookMailer < ApplicationMailer
  def part_email(subscription)
    @subscription = subscription
    @book = subscription.book
    window = @book.window(subscription.pos)
    return if window.none?
    @content = window.map(&:content).join("\n")

    total_words = @book.total_words
    words_so_far = @book.texts.where(pos: (0..window.last.pos)).sum(&:word_count)
    @part_of = "(#{(words_so_far.to_f / 1000).ceil} of #{(total_words.to_f / 1000).ceil})"

    Nokogiri::HTML(@content).css('img').each do |i|
      src = i.attribute('src').value
      name = src.split('/').last
      found = @book.images.find { |i| i.href.split('/').last == name }
      if found
        attachments.inline[name] = found.content
        @content = @content.gsub(src, attachments[name].url)
      end
    end

    mail(
      from: 'noreply@slashbooks.app',
      to: subscription.email,
      subject: "#{@part_of} #{@book.title} by #{@book.author}",
    )

    subscription.update!(pos: window.last.pos)
  end
end
