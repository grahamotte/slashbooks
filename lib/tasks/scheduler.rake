task send_email_parts: :environment do
  Subscription.all.each do |s|
    BookMailer.part_email(s).deliver_now
  end
end

task remove_unused_books: :environment do
  BookPart.where.not(book_id: Subscription.all.map(&:book_id)).destroy_all
end
