class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :initial_computer_hand
      t.string :initial_player_hand
      t.string :computer_discard
      t.string :player_discard
      t.string :cards_in_play
      t.string :winner
      t.string :initial_computer_hand_rank
      t.string :initial_player_hand_rank
      t.string :final_computer_hand_rank
      t.string :final_player_hand_rank

      t.timestamps
    end
  end
end
