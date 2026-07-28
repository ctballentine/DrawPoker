class AddIndexToGamesWinner < ActiveRecord::Migration[7.1]
  def change
    add_index :games, :winner, where: "winner IS NOT NULL"
  end
end
