
require 'pry'
class Deck
  attr_accessor :cards, :top_card
  
  def initialize
    @cards = []
    suits = ["Hearts", "Spades", "Diamonds", "Clubs"]
    values = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"]

    suits.each do |s|
      values.each do |v|
        card = Card.new(s, v)
        @cards << card
      end
    end

    shuffle_cards

  end

  def top_card
    cards.pop
  end

  def size
    cards.size
  end

  def shuffle_cards
    cards.shuffle!
  end

end

class Card
  attr_accessor :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "The #{value} of #{suit}"
  end

end

module Hand
  attr_accessor :cards, :total

  def show_hand
    puts "----- #{name}'s Hand -----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
  end

  def deal_card(new_card)
    cards << new_card
  end

  def total
    arr = cards.map{|e| e.value}

    total = 0
    arr.each do |value|
      if value == "Ace"
        total += 11
      elsif value.to_i == 0
        total += 10
      else
        total += value.to_i
      end
    end

    arr.select{|e| e == "Ace"}.count.times do
      if total > Game::BLACKJACK_AMOUNT
        total -= 10
      end
    end

    total

  end

  def bust?
    total > Game::BLACKJACK_AMOUNT
  end

  def blackjack?
    total == Game::BLACKJACK_AMOUNT
  end

end

class Player
  include Hand

  attr_accessor :name, :cards, :money, :bet

  def initialize(n)
    @name = n
    @cards = []
    @money = 100
    @bet = 0
  end

  def win_bet!(player, other_player)
    if other_player.total > 21
      puts "#{other_player.name} busts!"
    elsif player.total == 21
      puts "#{player.name} has blackjack!"
    end
    puts "#{player.name} wins this bet!"
    player.money += player.bet
  end

  def lose_bet!(player, other_player)
    if total > 21
      puts "#{player.name} busts!"
    elsif other_player.total == 21
      puts "#{other_player.name} has blackjack!"
    end
    puts "#{player.name} loses this bet!"
    player.money -= player.bet
  end

end


class Dealer < Player

  def show_flop
    puts "----- #{name}'s Hand -----"
    puts "=> #{cards[0]}"
    puts "=> Hidden Card"
  end

end

class Game
  attr_accessor :deck, :player, :dealer

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17

  def initialize
    @deck = Deck.new
    @player = Player.new(" ")
    @dealer = Dealer.new("Dealer")
  end

  def play
    get_name
    begin
      place_bet
      puts "Dealing cards..."
      deal_cards
      show_hands
      hit_or_stay unless winner?
      dealer_turn unless winner?
      compare_hands unless winner?
      check_winner
    end until play_again?
  end

  def get_name
    puts "Welcome to Blackjack! What's your name?"
    player.name = gets.chomp
  end

  def place_bet
    begin
      puts "How much you wanna bet on this round? You currently have $#{player.money}"
      player.bet = gets.chomp.to_i
    end until player.bet > 0 && player.bet <= player.money
  end

  def deal_cards
    dealer.deal_card(deck.top_card)
    dealer.deal_card(deck.top_card)
    player.deal_card(deck.top_card)
    player.deal_card(deck.top_card)
  end

  def show_hands
    dealer.show_flop
    player.show_hand
  end

  def hit_or_stay
    begin
      puts "Hit or Stay? Enter 'h' or 's'."
      choice = gets.chomp
    end until choice.downcase == 'h' || choice.downcase == 's'
    if choice.downcase == 'h'
      hit
    end
  end

  def hit
    player.deal_card(@deck.top_card)
    player.show_hand
    hit_or_stay unless winner?
  end

  def dealer_turn
    puts "Dealer's turn. Dealing cards..."
    dealer.show_hand
    while dealer.total < DEALER_HIT_MIN
      dealer.deal_card(deck.top_card)
      dealer.show_hand
    end
  end

  def compare_hands
    if player.total > dealer.total
      puts "#{player.name} has higher total than dealer. #{player.name} wins this bet!"
      player.money += player.bet
    elsif player.total < dealer.total
      puts "Dealer has higher total than #{player.name}. Dealer wins this bet!"
      player.money -= player.bet
    elsif player.total == dealer.total
      puts "It's a tie!"  
    end
  end

  def winner?
    player.blackjack? || player.bust? || dealer.blackjack? || dealer.bust?
  end

  def check_winner
    if player.blackjack? && dealer.blackjack?
      puts "#{player.name} and dealer are tied!"
    elsif player.bust? 
      player.lose_bet!(player, dealer)
    elsif dealer.bust?
      player.win_bet!(player, dealer)
    elsif player.blackjack? 
      player.win_bet!(player, dealer)
    elsif dealer.blackjack?
      player.lose_bet!(player, dealer)
    end
  end

  def play_again?
    puts "Play again? Enter 'y' for 'yes' or 'n' for 'no'."
    choice = gets.chomp
    if choice.downcase == 'y'
      if player.money <= 0 
        puts "Sorry, you've run out of money! Bye!"
        exit
      else
        deck = Deck.new
        player.cards = []
        dealer.cards =[]
        puts ""
        puts "Starting new game..."
        return false
      end
    else
      puts "Thanks for playing! You're leaving with $#{player.money}."
      exit
    end
    return true
  end

end

Game.new.play
