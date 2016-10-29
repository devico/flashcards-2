# This migration comes from api_flashcards (originally 20161022164802)
class AddTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :token, :string
  end
end
