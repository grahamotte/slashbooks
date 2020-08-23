task send_email_parts: :environment do
  Subscription.all.each do |s|
    BookMailer.part_email(s).deliver_now
  end
end

task remove_unused_books: :environment do
  active_book_ids = Subscription.all.map(&:book_id)
  Book.where.not(id: active_book_ids).destroy_all
  BookPart.where.not(book_id: active_book_ids).destroy_all
end
