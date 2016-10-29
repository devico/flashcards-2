class ParseCardsService
  attr_accessor :errors, :words
  attr_reader :node, :options, :user_id

  def initialize(user_id, options)
    @node = parse_resourse(options[:url])
    @user_id = user_id
    @options = options
    @errors = []
    @words = []
  end

  def parse_resourse(url)
    Nokogiri::HTML(open(url))
  rescue => e
    @errors << { msg: e.to_s }
  end

  def fix_encoding(text)
    begin
      text.encode("ISO-8859-1").force_encoding('UTF-8')
    rescue Encoding::UndefinedConversionError
      @errors << { msg: I18n.t('wrong_encoding_msg') }
    rescue => e
      @errors << { msg: e.to_s }
    end
  end

  def first_downcase_word(text)
    word = text.try(:downcase)

    begin
      word.match("([a-zA-Zа-яА-Я]+)")[0] if word
    rescue => e
      fix_encoding(text).match("([a-zA-Zа-яА-Я]+)")[0]
    end
  end

  def create_card!(original_text, translated_text)
    if original_text && translated_text
      card = Card.new(
        original_text: first_downcase_word(original_text),
        translated_text: first_downcase_word(translated_text),
        user_id: user_id,
        block_id: 1
      )

      if card.valid?
        card.save!
        words << { original: card.original_text, translated: translated_text }
      end
    end
  end

  def send_report_mail!
    CardsMailer.parsed_cards_notification(user_id, words, errors).deliver_now
  end

  def call
    node.search(options[:search_xpath]).each do |row|
      original_text   = row.search(options[:original_text_selector].rstrip).first
      translated_text = row.search(options[:translated_text_selector].rstrip).first

      create_card!(original_text.try(:content), translated_text.try(:content))
    end

    send_report_mail!
  end
end
