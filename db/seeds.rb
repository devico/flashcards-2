# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('https://www.learnathome.ru/blog/100-beautiful-words'))

doc.search('//table/tbody/tr').each do |row|
  original = row.search('td[2]')[0].content.downcase
  translated = row.search('td[4]')[0].content.downcase

  card = Card.new(
    original_text: original,
    translated_text: translated,
    user_id: 1,
    block_id: 1
  )

  msg =
    if card.save
      "Saved: #{card.id}. original_text: #{card.original_text} - " +
      "translated_text: #{card.translated_text} - user_id: #{card.user_id}"
    else
      card.errors.full_messages
    end

  puts msg
end


roles = [:admin, :moderator, :member]

roles.each.with_index do |role, index|
  user = User.create(email: "test_email#{index}@gmail.com", password: 123456, password_confirmation: 123456)
  user.add_role(role)

  puts "User created #{user.email} with role: #{role}"
end
