require 'rails_helper'

describe ParseCardsService do
  let(:user) { create(:user) }

  it 'returns array of words example #1' do
    options = {
      url: 'http://masterrussian.com/vocabulary/common_nouns.htm',
      search_xpath: '//table//tr[position() > 1]',
      original_text_selector: 'td[3]',
      translated_text_selector: 'td[2]'
    }

    VCR.use_cassette("parsed_cards_example1") do
      parse_card_service = ParseCardsService.new(user.id, options)
      parse_card_service.call

      expect(parse_card_service.words).not_to be_empty
    end
  end

  it 'returns array of words example #2' do
    options = {
      url: 'http://www.russianpod101.com/russian-word-lists/',
      search_xpath: '.wrapper_for_listjs>div',
      original_text_selector: '.ill-wlv__block-d .ill-wlv__section-b__wordline[3]>span[2]',
      translated_text_selector: '.ill-wlv__block-d .ill-wlv__section-b__wordline[1]>span[2]'
    }

    VCR.use_cassette("parsed_cards_example2") do
      parse_card_service = ParseCardsService.new(user.id, options)
      parse_card_service.call

      expect(parse_card_service.words).not_to be_empty
    end
  end

  it 'returns array of words example #3' do
    options = {
      url: 'https://quizlet.com/35024791/301-600-top-5000-words-in-russian-flash-cards',
      search_xpath: '.terms>div',
      original_text_selector: '.text p>span',
      translated_text_selector: '.text h3>span'
    }

    VCR.use_cassette("parsed_cards_example3") do
      parse_card_service = ParseCardsService.new(user.id, options)
      parse_card_service.call

      expect(parse_card_service.words).not_to be_empty
    end
  end
end
