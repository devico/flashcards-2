class CardTranslationService
  attr_accessor :user_translation, :card, :state, :levenshtein_distance

  MIN_DISTANCE = 1

  def initialize(card, user_translation)
    @card = card
    @user_translation = user_translation
    @state = false
  end

  def calculate_levenshtein_distance
    translated_text = card.send(:full_downcase, card.translated_text)
    user_translation_text = card.send(:full_downcase, user_translation)

    Levenshtein.distance(translated_text, user_translation_text)
  end

  def super_memo
    SuperMemo.algorithm(card, levenshtein_distance)
  end

  def reduce_sm_hash!
    @levenshtein_distance = calculate_levenshtein_distance

    if levenshtein_distance <= MIN_DISTANCE
      @state = true
      super_memo.merge!({ review_date: Time.current + card.interval.to_i.days, attempt: 1 })
    else
      super_memo.merge!({ attempt: [card.attempt + 1, 5].min })
    end
  end

  def call
    sm_hash = reduce_sm_hash!

    card.update(sm_hash)
    ResultHash.new({state: state, distance: levenshtein_distance})
  end

  private def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end

class ResultHash
  def initialize(hash_object)
    hash_object.each do |key, value|
      define_singleton_method key do
       instance_variable_set("@#{key}", value)
      end
    end
  end
end
