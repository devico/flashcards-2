require 'super_memo'

class Card < ActiveRecord::Base
  before_validation :set_review_date_as_now, on: :create

  belongs_to :user
  belongs_to :block

  attr_accessor :flickr_search_query, :remote_image_url

  REPEATING_QUANTITY = 4

  validate :texts_are_not_equal
  validates :user_id, presence: true
  validates :original_text, :translated_text, :review_date,
            presence: { message: 'Необходимо заполнить поле.' }
  validates :user_id, presence: { message: 'Ошибка ассоциации.' }
  validates :block_id,
            presence: { message: 'Выберите колоду из выпадающего списка.' }
  validates :interval, :repeat, :efactor, :quality, :attempt, presence: true

  mount_uploader :image, CardImageUploader

  scope :pending, -> { where('review_date <= ?', Time.current).order('RANDOM()') }
  scope :repeating, -> { where('quality < ?', REPEATING_QUANTITY).order('RANDOM()') }

  def self.first_pending
    pending.first
  end

  def self.first_repeating
    repeating.first
  end

  protected

  def set_review_date_as_now
    self.review_date = Time.current
  end

  def texts_are_not_equal
    if full_downcase(original_text) == full_downcase(translated_text)
      errors.add(:original_text, 'Вводимые значения должны отличаться.')
    end
  end

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end
