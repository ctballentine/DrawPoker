class AddFinalHandToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :final_computer_hand, :string
    add_column :games, :final_player_hand, :string
  end
end
