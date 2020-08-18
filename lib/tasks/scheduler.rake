task send_email_parts: :environment do
  Subscription.all.each do |s|
    BookMailer.part_email(s).deliver_later
  end
end
