class PokerStatController < ApplicationController
  def index
    @completed_games = Game.completed
    @total_games_count = @completed_games.count
    @total_hands_count = @total_games_count * 2

    if @total_games_count.zero?
      set_empty_stats
      return
    end

    win_counts = @completed_games.group(:winner).count
    @player_wins = win_counts['player wins'] || 0
    @computer_wins = win_counts['computer wins'] || 0

    @player_win_per = ((@player_wins.to_f / @total_games_count) * 100).round(2)
    @computer_win_per = ((@computer_wins.to_f / @total_games_count) * 100).round(2)

    p_hand_counts = @completed_games.group(:final_player_hand_rank).count
    c_hand_counts = @completed_games.group(:final_computer_hand_rank).count

    p_win_hand_counts = @completed_games.where(winner: 'player wins').group(:final_player_hand_rank).count
    c_win_hand_counts = @completed_games.where(winner: 'computer wins').group(:final_computer_hand_rank).count

    @hand_types = [
      "royal flush", "straight flush", "four of a kind", "full house",
      "flush", "straight", "three of a kind", "two pairs", "one pair", "nothing"
    ]

    @stats = @hand_types.each_with_object({}) do |hand, hash|
      p_count = p_hand_counts[hand] || 0
      c_count = c_hand_counts[hand] || 0
      total_occurrences = p_count + c_count

      occur_per = ((total_occurrences.to_f / @total_hands_count) * 100).round(2)

      p_wins = p_win_hand_counts[hand] || 0
      c_wins = c_win_hand_counts[hand] || 0
      total_wins = p_wins + c_wins

      win_per = total_occurrences > 0 ? ((total_wins.to_f / total_occurrences) * 100).round(2) : 0

      hash[hand] = {
        number: total_occurrences,
        occur_per: "#{occur_per}%",
        win_per: "#{win_per}%"
      }
    end
  end

  private

  def set_empty_stats
    @player_wins = @computer_wins = @player_win_per = @computer_win_per = 0
    @hand_types = ["royal flush", "straight flush", "four of a kind", "full house", "flush", "straight", "three of a kind", "two pairs", "one pair", "nothing"]
    @stats = @hand_types.each_with_object({}) do |hand, hash|
      hash[hand] = { number: 0, occur_per: "0.0%", win_per: "0.0%" }
    end
  end
end
