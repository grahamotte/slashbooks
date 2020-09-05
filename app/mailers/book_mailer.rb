class BookMailer < ApplicationMailer
  def part_email(subscription)
    @subscription = subscription
    @book = subscription.book
    @window = subscription.current_window
    @content = @window.map(&:content).join("\n")

    return if subscription.done?

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
      from: 'robot@slashbooks.app',
      to: subscription.email,
      subject: "(#{@subscription.messages_so_far_count} of #{@subscription.messages_total_count}) #{@book.title} by #{@book.author}",
    )

    subscription.update!(pos: @subscription.current_window.last.pos)
  end
end
