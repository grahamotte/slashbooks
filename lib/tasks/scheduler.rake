task send_email_parts: :environment do
  Subscription.all.each do |s|
    puts s.uuid
    puts s.email
    BookMailer.part_email(s).deliver_now
  end
end
