module DrawPokerLogic
def draw_card
  card = {}
  card[1]="ACE"
  card[2]="2"
  card[3]="3"
  card[4]="4"
  card[5]="5"
  card[6]="6"
  card[7]="7"
  card[8]="8"
  card[9]="9"
  card[10]="10"
  card[11]="JACK"
  card[12]="QUEEN"
  card[13]="KING"
  suit = ["SPADES","HEARTS","DIAMONDS","CLUBS"]
  picked_card = card[rand(1..13)]
  picked_suit = suit[rand(4)]
  return_card = picked_card + " of " + picked_suit
  return return_card
end


#####first argument determines how many cards are dealt
#####second argument is an array of cards already on table
####if conditional makes sure no cards are duplicated
####by only adding cards not included to the hand
def deal(number,dealt=[])
  hand = []
  while hand.length < number
    card = draw_card
      if hand.include?(card) or dealt.include?(card)
      else
        hand<< card
      end
    end
  return hand
end

### first array is the player's hand
### second array are indicies of cards discarded
### function will return the discarded cards
### and delete them from the original hand
def discard(hand=[],drop=[])
  return_discard = []
  sort_drop = drop.sort {|a,b| b <=> a}
  sort_drop.each do |card|
    return_discard << hand[card]
    hand.delete_at(card)
  end
  return return_discard
end

def is_flush?(hand)
  suit_array=[]
  hand.each do |card|
    suit_array<< card.split(' ')[2]
  end
  if suit_array.uniq.length == 1
    return true
  else
    return false
  end
end


def pair_analyzer(hand)
  pair_array=[]
  hand.each do |card|
    pair_array<< card.split(' ')[0]
  end
  if pair_array.uniq.length == 2
    if pair_array.count(pair_array[0]) == 4 || pair_array.count(pair_array[0]) == 1
      return "four of a kind"
    elsif pair_array.count(pair_array[0]) == 3 || pair_array.count(pair_array[0]) == 2
      return "full house"
    end
  elsif pair_array.uniq.length == 3
    if pair_array.count(pair_array[0]) == 2 || pair_array.count(pair_array[1]) == 2  
      return "two pairs"
    else
      return "three of a kind"
    end
  elsif pair_array.uniq.length == 4
      return "one pair"
  elsif pair_array.uniq.length == 5
    return false
  end  
end

def get_card_value(card)
  cards={}
  cards["ACE"]=1
  cards["2"]=2
  cards["3"]=3
  cards["4"]=4
  cards["5"]=5
  cards["6"]=6
  cards["7"]=7
  cards["8"]=8
  cards["9"]=9
  cards["10"]=10
  cards["JACK"]=11
  cards["QUEEN"]=12
  cards["KING"]=13
  value=cards[card.split(' ')[0]]
end


#### this function assumes that the hand has no pairs in it
#### a hand with pairs might return a false positive
#### check for pairs first
def is_straight?(hand)
  royal=[1,10,11,12,13]
  tmp_array=[]
  hand.each {|card| tmp_array << get_card_value(card)}
  if tmp_array.max - tmp_array.min == 4 || tmp_array.sort == royal
    return true
  else
    return false
  end
end

def is_royal?(hand)
  royal=[1,10,11,12,13]
  tmp_array=[]
  hand.each {|card| tmp_array << get_card_value(card)}
  if tmp_array.sort == royal
    return true
  else
    return false
  end
end

def determine_high_card(hand)
  tmp_array=[]
  hand.each_with_index {|card,i| tmp_array[i] = get_card_value(card)} 
  if tmp_array.min == 1
    high_card_index = tmp_array.find_index(1)
    high_card=hand[high_card_index]
  else
    high_card_index = tmp_array.find_index(tmp_array.max)
    high_card=hand[high_card_index]
  end
  return high_card
end


def determine_hand(hand)
  if pair_analyzer(hand) == false
    if is_flush?(hand) == true && is_straight?(hand) == true && is_royal?(hand) == true 
      hand_name = "royal flush"
    elsif is_flush?(hand) == true && is_straight?(hand) == true && is_royal?(hand) == false
      hand_name = "straight flush"
    elsif is_flush?(hand) == true && is_straight?(hand) == false
      hand_name = "flush"
    elsif is_flush?(hand) == false && is_straight?(hand) == true 
      hand_name = "straight"
    elsif is_flush?(hand) == false && is_straight?(hand) == false
      hand_name = "nothing"
    end    
  else
    hand_name = pair_analyzer(hand)
  end
  return hand_name
end

def get_hand_value(hand)
  hands={}
  hands["royal flush"]=9
  hands["straight flush"]=8
  hands["four of a kind"]=7
  hands["full house"]=6
  hands["flush"]=5
  hands["straight"]=4
  hands["three of a kind"]=3
  hands["two pairs"]=2
  hands["one pair"]=1
  hands["nothing"]=0
  hand_value=hands[determine_hand(hand)]
end

def compare_hands(computer_hand,player_hand)
  computer_value=get_hand_value(computer_hand)
  player_value=get_hand_value(player_hand)
  if computer_value > player_value 
    return_string= "computer wins"
  elsif player_value > computer_value
    return_string= "player wins"
  elsif player_value == computer_value
    return_string= break_tie(computer_hand,player_hand)
  end
  return return_string
end


#### discard functions return an array with the indicies that should be discarded
def discard_two_pairs(hand)
  hand_value=[]
  hand.each_with_index {|card,i| hand_value[i]=get_card_value(card)}
  index_array=[]
  hand_value.each_with_index do |card,i|
    if hand_value.count(card) == 1
      index_array << i
    end
  end
  return index_array
end


def discard_four_of_a_kind(hand)
  hand_value=[]
  hand.each_with_index {|card,i| hand_value[i]=get_card_value(card)}
  index_array=[]
  hand_value.each_with_index do |card,i|
    if hand_value.count(card) == 1 && card != 1
      index_array << i
    end
  end
  return index_array
end


def discard_three_of_a_kind(hand)
  hand_value=[]
  hand.each_with_index {|card,i| hand_value[i]=get_card_value(card)}
  index_array=[]
  hand_value.each_with_index do |card,i|
    if hand_value.count(card) == 1 && card != 1
      index_array << i
    end
  end
  return index_array
end

def discard_one_pair(hand)
  hand_value=[]
  hand.each_with_index {|card,i| hand_value[i]=get_card_value(card)}
  nonpair_array=[]
  hand_value.each_with_index do |card,i|
    if hand_value.count(card) == 1 && card != 1
      nonpair_array << i
    end
  end
  index_array=[]
  nonpair_value=[]
  nonpair_array.each {|card| nonpair_value << hand_value[card]}
  if hand_value.count(1) == 1
    index_array = nonpair_array
  elsif nonpair_value.max < 10
    index_array = nonpair_array
  else
    nonpair_array.each do |card|
      if hand_value[card] != nonpair_value.max
        index_array << card
      end
    end
  end    
  return index_array
end


def is_four_flush?(hand)
  four_flush_key=[1,4]
  four_flush_flag=false
  suit_array=[]
  hand.each do |card|
    suit_array<< card.split(' ')[2]
  end
  if suit_array.uniq.length == 2
    if four_flush_key.include?(suit_array.count(suit_array[0]))
      four_flush_flag=true
    end
  end
  return four_flush_flag
end

def discard_four_flush(hand)
  suit_array=[]
discard_suit=""
  discard_index=[]
  hand.each do |card|
    suit_array<< card.split(' ')[2]
  end
  suit_array.each do |card|
    if suit_array.count(card)==1
      discard_suit=card
    end
  end
  hand.each_with_index do |card,i|
    if card.split(' ')[2] == discard_suit
      discard_index << i
    end
  end
  return discard_index
end


def get_number_of_face_cards(hand)
  num_face_cards=0
  card_value_array=[]
  hand.each{|card| card_value_array << get_card_value(card)}
  card_value_array.each do |card|
    if card == 1 || card >= 10
      num_face_cards+=1 
    end
  end
  return num_face_cards
end


def discard_non_face_card(hand)
  return_index=[]
  card_value_array=[]
  hand.each_with_index{|card,i| card_value_array[i]=get_card_value(card)}
  card_value_array.each_with_index do |card,i|
    if card == 1 || card >= 10
    else
      return_index << i
    end
  end
  return return_index
end

def has_ace?(hand)
  card_value_array=[]
  hand.each_with_index{|card,i| card_value_array[i]=get_card_value(card)}
  if card_value_array.include?(1)
    return true
  else
    return false
  end
end

def is_four_straight?(hand)
  ##### sort array of card values from lowest to highest (by this point in the algorithim there should not be an ace)
  ##### if [4]-[1] is == 3 OR [3]-[0] is == 1
  ##### it's a four straight 
  card_value_array=[]
  hand.each{|card| card_value_array << get_card_value(card)}
  sorted_array=card_value_array.sort
  if sorted_array[4] - sorted_array[1] == 3 || sorted_array[3] - sorted_array[0] == 3
    return true
  else
    return false
  end   
end


def discard_four_straight(hand)
  #### get a sort array of card values. if [1]-[0] > 1, set [0] as discard value. if [4]-[3] > 1, set [4] as a discard value
  #### do an each_with_index on the hand and match for the discard value and return the index
  discard_value=""
  discard_array=[]
  card_value_array=[]
  hand.each_with_index{|card,i| card_value_array[i]=get_card_value(card)}
  sorted_array=card_value_array.sort
  if sorted_array[1] - sorted_array[0] > 1
    discard_value=sorted_array[0]
  elsif sorted_array[4] - sorted_array[3] > 1
    discard_value=sorted_array[4]
  end
  card_value_array.each_with_index do |card,i|
    if card == discard_value
      discard_array << i
    end
  end
  return discard_array
end

def is_three_flush?(hand)
  ##### use split function to make an array of suits. Check the count value of each member. If any of them equal 3, it's a three flush
  ##### maybe set a three_flush_flag and an if statement that sets it to true if the count is equal to 3
  three_flush_flag=false
  suit_array=[]
  hand.each do |card|
    suit_array<< card.split(' ')[2]
  end
  suit_array.each do |card|
    if suit_array.count(card) == 3
      three_flush_flag=true
    end
  end
  return three_flush_flag
end

def discard_three_flush(hand)
  ##### use an indexed split function to make an array of suits. Check the count value of each member with an each_with_index
  ##### if count is less than 3, send the index to an array
  suit_array=[]
  discard_array=[]
  hand.each_with_index do |card,i|
    suit_array[i]=card.split(' ')[2]
  end
  suit_array.each_with_index do |card,i|
    if suit_array.count(card) < 3
      discard_array << i
    end
  end
  return discard_array
end


def discard_nothing(hand)
  discard_array=[]
  three_flush_array=[]
  if is_four_flush?(hand) == true
    discard_array=discard_four_flush(hand)
  elsif get_number_of_face_cards(hand) >= 3
    discard_array=discard_non_face_card(hand)
  elsif has_ace?(hand) == true
    discard_array=discard_non_face_card(hand)
  elsif is_four_straight?(hand) == true
    discard_array=discard_four_straight(hand)
  elsif is_three_flush?(hand)
    discard_three_flush(hand).each {|index| three_flush_array << hand[index]}
    if get_number_of_face_cards(three_flush_array) == 0  
      discard_array=discard_three_flush(hand)
    else 
      discard_array=discard_non_face_card(hand)
    end  
  else discard_array=discard_non_face_card(hand)
  end
  return discard_array    
end

def automatic_discard(hand)
  return_index=[]
  hand_value=determine_hand(hand)
  if hand_value == "royal flush"
    return_index=[]
  elsif hand_value == "straight flush"
    return_index=[]
  elsif hand_value == "four of a kind"
    return_index=discard_four_of_a_kind(hand)
  elsif hand_value == "full house"
    return_index=[]
  elsif hand_value == "flush"
    return_index=[]
  elsif hand_value == "straight"
    return_index=[]
  elsif hand_value == "three of a kind"
    return_index=discard_three_of_a_kind(hand)
  elsif hand_value == "two pairs"
    return_index=discard_two_pairs(hand)
  elsif hand_value == "one pair"
    return_index=discard_one_pair(hand)
  elsif hand_value == "nothing"
    return_index=discard_nothing(hand)
  end
  return return_index
end

def compare_nothing(computer_hand,player_hand)
####compare the high card, then the next highest and so on. If they're all tied
####then it's a tie
  player_hand_value=[]
  player_hand.each_with_index {|card,i| player_hand_value[i]=get_card_value(card)}
  sorted_player_hand_value=player_hand_value.sort {|a,b| b <=> a}
  computer_hand_value=[]
  computer_hand.each_with_index {|card,i| computer_hand_value[i]=get_card_value(card)}
  sorted_computer_hand_value=computer_hand_value.sort {|a,b| b <=> a}
  if has_ace?(computer_hand) == true && has_ace?(player_hand) == false
    return "computer wins"
  elsif has_ace?(computer_hand) == false && has_ace?(player_hand) == true
    return "player wins"
  else
    if sorted_player_hand_value[0] > sorted_computer_hand_value[0]
      return "player wins"
    elsif sorted_player_hand_value[0] < sorted_computer_hand_value[0]
      return "computer wins"
    elsif sorted_player_hand_value[0] == sorted_computer_hand_value[0]
      if sorted_player_hand_value[1] > sorted_computer_hand_value[1]
        return "player wins"
      elsif sorted_player_hand_value[1] < sorted_computer_hand_value[1]
        return "computer wins"
      elsif sorted_player_hand_value[1] == sorted_computer_hand_value[1]
        if sorted_player_hand_value[2] > sorted_computer_hand_value[2]
          return "player wins"
        elsif sorted_player_hand_value[2] < sorted_computer_hand_value[2]
          return "computer wins"
        elsif sorted_player_hand_value[2] == sorted_computer_hand_value[2]
          if sorted_player_hand_value[3] > sorted_computer_hand_value[3]
            return "player wins"
          elsif sorted_player_hand_value[3] < sorted_computer_hand_value[3]
            return "computer wins"
          elsif sorted_player_hand_value[3] == sorted_computer_hand_value[3]
            if sorted_player_hand_value[4] > sorted_computer_hand_value[4]
              return "player wins"
            elsif sorted_player_hand_value[4] < sorted_computer_hand_value[4]
              return "computer wins"
            elsif sorted_player_hand_value[4] == sorted_computer_hand_value[4]
              if sorted_player_hand_value[5] > sorted_computer_hand_value[5]
                return "player wins"
              elsif sorted_player_hand_value[5] < sorted_computer_hand_value[5]
                return "computer wins"
              elsif sorted_player_hand_value[5] == sorted_computer_hand_value[5]
              end 
            end 
          end 
        end 
      end 
    end  
  end
end


def compare_one_pair(computer_hand,player_hand)
###compare the pair, if the same, check the highest single card
###if that's tied, the next highest and if that's tied the nest highest
###and if that's the same too, then it's a tie
  player_hand_value=[]
  player_hand.each_with_index {|card,i| player_hand_value[i]=get_card_value(card)}
  player_pair_value=[]
  player_nonpair_value=[]
  player_hand_value.each do |card|
    if player_hand_value.count(card) == 2
      player_pair_value << card
    else 
      player_nonpair_value << card
    end
  end
  computer_hand_value=[]
  computer_hand.each_with_index {|card,i| computer_hand_value[i]=get_card_value(card)}
  computer_pair_value=[]
  computer_nonpair_value=[]
  computer_hand_value.each do |card|
    if computer_hand_value.count(card) == 2
      computer_pair_value << card
    else 
      computer_nonpair_value << card
    end
  end
  sorted_player_nonpair_value=player_nonpair_value.sort {|a,b| b <=> a}
  sorted_computer_nonpair_value=computer_nonpair_value.sort {|a,b| b <=> a}
  if player_pair_value.include?(1) == true && computer_pair_value.include?(1) == false
    return "player wins"
  elsif player_pair_value.include?(1) == false && computer_pair_value.include?(1) == true
    return "computer wins"
  else
    if player_pair_value[0] > computer_pair_value[0]
      return "player wins"
    elsif computer_pair_value[0] > player_pair_value[0]
      return "computer wins"
    elsif computer_pair_value[0] == player_pair_value[0]
      if sorted_player_nonpair_value.include?(1) == true && sorted_computer_nonpair_value.include?(1) == false
        return "player wins"
      elsif sorted_player_nonpair_value.include?(1) == false && sorted_computer_nonpair_value.include?(1) == true
        return "computer wins"
      else
        if sorted_player_nonpair_value[0] > sorted_computer_nonpair_value[0]
          return "player wins"
        elsif sorted_computer_nonpair_value[0] > sorted_player_nonpair_value[0]
          return "computer wins"
        elsif sorted_computer_nonpair_value[0] == sorted_player_nonpair_value[0]
          if sorted_player_nonpair_value[1] > sorted_computer_nonpair_value[1]
            return "player wins"
          elsif sorted_computer_nonpair_value[1] > sorted_player_nonpair_value[1]
            return "computer wins"
          elsif sorted_computer_nonpair_value[1] == sorted_player_nonpair_value[1]
            if sorted_player_nonpair_value[2] > sorted_computer_nonpair_value[2]
              return "player wins"
            elsif sorted_computer_nonpair_value[2] > sorted_player_nonpair_value[2]
              return "computer wins"
            elsif sorted_computer_nonpair_value[2] == sorted_player_nonpair_value[2]
              return "tied"
            end
          end
        end
      end
    end
  end
end

def compare_two_pairs(computer_hand,player_hand)
####compare high pair, if tied, compare low pair
####if both pairs tied, check the single card
####if that's tied, it's a tie
  player_hand_value=[]
  player_hand.each_with_index {|card,i| player_hand_value[i]=get_card_value(card)}
  player_pair_value=[]
  player_nonpair_value=[]
  player_hand_value.each do |card|
    if player_hand_value.count(card) == 2
      player_pair_value << card
    else 
      player_nonpair_value << card
    end
  end
  computer_hand_value=[]
  computer_hand.each_with_index {|card,i| computer_hand_value[i]=get_card_value(card)}
  computer_pair_value=[]
  computer_nonpair_value=[]
  computer_hand_value.each do |card|
    if computer_hand_value.count(card) == 2
      computer_pair_value << card
    else 
      computer_nonpair_value << card
    end
  end
  if player_pair_value.include?(1) == true && computer_pair_value.include?(1) == false
    return "player wins"
  elsif player_pair_value.include?(1) == false && computer_pair_value.include?(1) == true
    return "computer wins"
  else 
    if player_pair_value.max > computer_pair_value.max 
      return "player wins"
    elsif player_pair_value.max < computer_pair_value.max  
      return "computer wins"
    elsif player_pair_value.max == computer_pair_value.max  
      if player_pair_value.min > computer_pair_value.min 
        return "player wins"
      elsif player_pair_value.min < computer_pair_value.min
        return "computer wins"
      elsif player_pair_value.min == computer_pair_value.min
        if player_nonpair_value.include?(1) == true && computer_nonpair_value.include?(1) == false
          return "player wins"
        elsif player_nonpair_value.include?(1) == false && computer_nonpair_value.include?(1) == true
          return "computer wins"
        else 
          if player_nonpair_value[0] > computer_nonpair_value[0]
            return "player wins"
          elsif  player_nonpair_value[0] < computer_nonpair_value[0]
            return "computer wins"
          else
            return "tied"
          end
        end
      end
    end  
  end
end


def compare_three_of_a_kind(computer_hand,player_hand)
####whichever of the three of a kind is higher is the winner
####a tie should not be possible
####will basically be the same algo as full house
  player_hand_value=[]
  player_hand.each_with_index {|card,i| player_hand_value[i]=get_card_value(card)}
  player_pair_value=[]
  player_hand_value.each do |card|
    if player_hand_value.count(card) == 3
      player_pair_value << card
    end
  end
  computer_hand_value=[]
  computer_hand.each_with_index {|card,i| computer_hand_value[i]=get_card_value(card)}
  computer_pair_value=[]
  computer_hand_value.each do |card|
    if computer_hand_value.count(card) == 3
      computer_pair_value << card
    end
  end
  if player_pair_value.include?(1) == true && computer_pair_value.include?(1) == false
    return "player wins"
  elsif player_pair_value.include?(1) == false && computer_pair_value.include?(1) == true
    return "computer wins"
  else
    if player_pair_value[0] > computer_pair_value[0]
      return "player wins"   
    elsif player_pair_value[0] < computer_pair_value[0]
      return "computer wins"
    end
  end
end

def compare_straight(computer_hand,player_hand)
####check the highest card. whichever is higher is the winner
####if they're the same, it's a tie
  player_high_card=determine_high_card(player_hand)
  player_high_card_value=get_card_value(player_high_card)
  computer_high_card=determine_high_card(computer_hand)
  computer_high_card_value=get_card_value(computer_high_card)
  if player_high_card_value == 1 && computer_high_card_value != 1
    return "player wins"
  elsif player_high_card_value != 1 && computer_high_card_value == 1
    return "computer wins"
  elsif player_high_card_value == 1 && computer_high_card_value == 1
    return "tied"
  else
    if player_high_card_value > computer_high_card_value
      return "player wins"
    elsif player_high_card_value < computer_high_card_value
      return "computer wins"
    else
      return "tied"
    end
  end
end

def compare_flush(computer_hand,player_hand)
####check the highest card...if it's a tie
####check the nest highest and so on. if all the same
####it's a tie
  player_hand_value=[]
  player_hand.each_with_index {|card,i| player_hand_value[i]=get_card_value(card)}
  sorted_player_hand_value=player_hand_value.sort {|a,b| b <=> a}
  computer_hand_value=[]
  computer_hand.each_with_index {|card,i| computer_hand_value[i]=get_card_value(card)}
  sorted_computer_hand_value=computer_hand_value.sort {|a,b| b <=> a}
  if has_ace?(computer_hand) == true && has_ace?(player_hand) == false
    return "computer wins"
  elsif has_ace?(computer_hand) == false && has_ace?(player_hand) == true
    return "player wins"
  else
    if sorted_player_hand_value[0] > sorted_computer_hand_value[0]
      return "player wins"
    elsif sorted_player_hand_value[0] < sorted_computer_hand_value[0]
      return "computer wins"
    elsif sorted_player_hand_value[0] == sorted_computer_hand_value[0]
      if sorted_player_hand_value[1] > sorted_computer_hand_value[1]
        return "player wins"
      elsif sorted_player_hand_value[1] < sorted_computer_hand_value[1]
        return "computer wins"
      elsif sorted_player_hand_value[1] == sorted_computer_hand_value[1]
        if sorted_player_hand_value[2] > sorted_computer_hand_value[2]
          return "player wins"
        elsif sorted_player_hand_value[2] < sorted_computer_hand_value[2]
          return "computer wins"
        elsif sorted_player_hand_value[2] == sorted_computer_hand_value[2]
          if sorted_player_hand_value[3] > sorted_computer_hand_value[3]
            return "player wins"
          elsif sorted_player_hand_value[3] < sorted_computer_hand_value[3]
            return "computer wins"
          elsif sorted_player_hand_value[3] == sorted_computer_hand_value[3]
            if sorted_player_hand_value[4] > sorted_computer_hand_value[4]
              return "player wins"
            elsif sorted_player_hand_value[4] < sorted_computer_hand_value[4]
              return "computer wins"
            elsif sorted_player_hand_value[4] == sorted_computer_hand_value[4]
              if sorted_player_hand_value[5] > sorted_computer_hand_value[5]
                return "player wins"
              elsif sorted_player_hand_value[5] < sorted_computer_hand_value[5]
                return "computer wins"
              elsif sorted_player_hand_value[5] == sorted_computer_hand_value[5]
              end 
            end 
          end 
        end 
      end 
    end  
  end
end

def compare_full_house(computer_hand,player_hand)
####check the three of a kind cards
####a tie should not be possible
  player_hand_value=[]
  player_hand.each_with_index {|card,i| player_hand_value[i]=get_card_value(card)}
  player_pair_value=[]
  player_hand_value.each do |card|
    if player_hand_value.count(card) == 3
      player_pair_value << card
    end
  end
  computer_hand_value=[]
  computer_hand.each_with_index {|card,i| computer_hand_value[i]=get_card_value(card)}
  computer_pair_value=[]
  computer_hand_value.each do |card|
    if computer_hand_value.count(card) == 3
      computer_pair_value << card
    end
  end
  if player_pair_value.include?(1) == true && computer_hand_value.include?(1) == false
    return "player wins"
  elsif player_pair_value.include?(1) == false && computer_hand_value.include?(1) == true
    return "computer wins"
  else
    if player_pair_value[0] > computer_pair_value[0]
      return "player wins"   
    elsif player_pair_value[0] < computer_pair_value[0]
      return "computer wins"
    end
  end
end

def compare_four_of_a_kind(computer_hand,player_hand)
####check the paired cards. A tie should not be possible
  player_hand_value=[]
  player_hand.each_with_index {|card,i| player_hand_value[i]=get_card_value(card)}
  player_pair_value=[]
  player_hand_value.each do |card|
    if player_hand_value.count(card) == 4
      player_pair_value << card
    end
  end
  computer_hand_value=[]
  computer_hand.each_with_index {|card,i| computer_hand_value[i]=get_card_value(card)}
  computer_pair_value=[]
  computer_hand_value.each do |card|
    if computer_hand_value.count(card) == 4
      computer_pair_value << card
    end
  end
  if player_pair_value.include?(1) == true && computer_pair_value.include?(1) == false
    return "player wins"
  elsif player_pair_value.include?(1) == false && computer_pair_value.include?(1) == true
    return "computer wins"
  else
    if player_pair_value[0] > computer_pair_value[0]
      return "player wins"   
    elsif player_pair_value[0] < computer_pair_value[0]
      return "computer wins"
    end
  end
end

def compare_stright_flush(computer_hand,player_hand)
####check each hand's high cards. whichever is the highest
####is the winner. If they're tied, it's a tie
  player_high_card=determine_high_card(player_hand)
  player_high_card_value=get_card_value(player_high_card)
  computer_high_card=determine_high_card(computer_hand)
  computer_high_card_value=get_card_value(computer_high_card)
  if player_high_card_value == 1 && computer_high_card_value != 1
    return "player wins"
  elsif player_high_card_value != 1 && computer_high_card_value == 1
    return "computer wins"
  elsif player_high_card_value == 1 && computer_high_card_value == 1
    return "tied"
  else
    if player_high_card_value > computer_high_card_value
      return "player wins"
    elsif player_high_card_value < computer_high_card_value
      return "computer wins"
    else
      return "tied"
    end
  end
end

def compare_royal_flush(computer_hand,player_hand)
##### two Royal flushes will always tie
##### these rules do not give weight
##### to suits
  return "tied"
end

def break_tie(computer_hand,player_hand)
  result=""
  hand_value=determine_hand(computer_hand)
  if hand_value == "royal flush"
    result=compare_royal_flush(computer_hand,player_hand)
  elsif hand_value == "straight flush"
    result=compare_stright_flush(computer_hand,player_hand)
  elsif hand_value == "four of a kind"
    result=compare_four_of_a_kind(computer_hand,player_hand)
  elsif hand_value == "full house"
    result=compare_full_house(computer_hand,player_hand)
  elsif hand_value == "flush"
    result=compare_flush(computer_hand,player_hand)
  elsif hand_value == "straight"
    result=compare_straight(computer_hand,player_hand)
  elsif hand_value == "three of a kind"
    result=compare_three_of_a_kind(computer_hand,player_hand)
  elsif hand_value == "two pairs"
    result=compare_two_pairs(computer_hand,player_hand)
  elsif hand_value == "one pair"
    result=compare_one_pair(computer_hand,player_hand)
  elsif hand_value == "nothing"
    result=compare_nothing(computer_hand,player_hand)
  end
  return result  
end


###for use in converting an array to a csv string which can be stored in the sql database
def to_string(hand)
  returnString = ""
  hand.each_with_index do |x,i|
    returnString += x
  if i+1 < hand.length
    returnString += ","
    end
  end
  return returnString
end



end













