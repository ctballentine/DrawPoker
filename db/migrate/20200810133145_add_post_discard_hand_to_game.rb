class AddPostDiscardHandToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :post_discard_computer_hand, :string
    add_column :games, :post_discard_player_hand, :string
  end
end
