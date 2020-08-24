class GamesController < ApplicationController
load "#{Rails.root}/lib/assets/DrawPokerLogic.rb"
include DrawPokerLogic
  def new

    @game=Game.new
      ## deals hand to computer, saves its values and rank to the database 
      initial_computer_hand_array=deal(5)
      @game.initial_computer_hand=to_string(initial_computer_hand_array)
      @game.initial_computer_hand_rank=determine_hand(initial_computer_hand_array)
   
      ## deals hand to player, saves its values and rank to the database
      initial_player_hand_array=deal(5,initial_computer_hand_array)
      @game.initial_player_hand=to_string(initial_player_hand_array)
      @game.initial_player_hand_rank=determine_hand(initial_player_hand_array)

      @game.save


      respond_to do |format|
        format.html
        format.js { render :action => 'new' }

      end
  end

  def index
  end

  def show
      @game=Game.find(params[:game])
      initial_hand_array=@game.initial_player_hand.split(',')
      @suggestedDiscard=automatic_discard(initial_hand_array)

      respond_to do |format|
        format.js { render :action => 'show' }
      end
  end

  def edit
    @game=Game.find(params[:game])
    player_discard_selection=[]
    discard_params=params[:discard]
    if discard_params
     discard_params.each do |x|
     player_discard_selection << x.to_i
     end
    end

    
    if @game.winner == nil
    initial_player_hand_array=@game.initial_player_hand.split(",")
    initial_computer_hand_array=@game.initial_computer_hand.split(",")
    cards_in_play = initial_player_hand_array + initial_computer_hand_array


    computer_discard_array=discard(initial_computer_hand_array,automatic_discard(initial_computer_hand_array))
    @game.computer_discard=to_string(computer_discard_array)
    ####player discard selection will be an array from the screen instead of the automatic discard
    player_discard_array=discard(initial_player_hand_array,player_discard_selection)
    @game.player_discard=to_string(player_discard_array)

    new_computer_cards=deal(computer_discard_array.length,cards_in_play)
    final_computer_hand_array=new_computer_cards + initial_computer_hand_array
    cards_in_play += new_computer_cards
    @game.final_computer_hand=to_string(final_computer_hand_array)

    final_player_hand_array=deal(player_discard_array.length,cards_in_play) +  initial_player_hand_array
    @game.final_player_hand=to_string(final_player_hand_array)

    @game.winner = compare_hands(final_computer_hand_array,final_player_hand_array)

    @game.final_player_hand_rank=determine_hand(final_player_hand_array)
    @game.final_computer_hand_rank=determine_hand(final_computer_hand_array)

    @game.save

      respond_to do |format|
        format.js { render :action => 'edit' }
      end
    end

  end
end




