
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
    if total > Game::BLACKJACK_AMOUNT
      return true
    else
      return false
    end
  end

  def blackjack?
    if total == Game::BLACKJACK_AMOUNT
      return true
    else
      return false
    end
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

end


class Dealer < Player

  def show_flop
    puts "----- #{name}'s Hand -----"
    puts "=> #{cards[0]}"
    puts "=> Hidden Card"
  end

end

class Game
  attr_accessor :deck, :player, :dealer, :end_game

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17

  def initialize
    @deck = Deck.new
    @player = Player.new(" ")
    @dealer = Dealer.new("Dealer")
    @end_game = false

  end

  def get_name
    puts "Welcome to Blackjack! What's your name?"
    player.name = gets.chomp
  end

  def place_bet
    begin
      puts "How much you wanna bet on this round? You currently have $#{player.money}"
      player.bet = gets.chomp.to_i
    end until player.bet != 0 && player.bet <= player.money
  end

  def start
    puts "Dealing cards..."
    deal_cards
    show_hands
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
    elsif choice.downcase == 's'
      stay
    end
  end

  def hit
    player.deal_card(@deck.top_card)
    player.show_hand
  end

  def stay
    puts "Dealer's turn. Dealing cards..."
    dealer.show_hand
    while dealer.total < DEALER_HIT_MIN
      dealer.deal_card(deck.top_card)
      dealer.show_hand
    end
    @end_game = true
  end

  def winner?
    if player.bust? || dealer.bust? || player.blackjack? || dealer.blackjack?
      return true
    else
      return false
    end
  end

  def winning_msg
    if player.blackjack? && dealer.blackjack?
      puts "#{player.name} and dealer are tied!"
    elsif player.bust?
      puts "#{player.name} busts! Dealer wins!"
      player.money -= player.bet
    elsif player.blackjack?
      puts "#{player.name} has #{BLACKJACK_AMOUNT.to_s}! #{player.name} wins!"
      player.money += player.bet
    elsif dealer.blackjack?
      puts "Dealer has #{BLACKJACK_AMOUNT.to_s}! Dealer wins!"
      player.money -= player.bet 
    elsif dealer.bust?
      puts "Dealer busts! #{player.name} wins!"
      player.money += player.bet
    elsif player.total > dealer.total
      puts "#{player.name} has higher total than dealer. #{player.name} wins!"
      player.money += player.bet
    elsif player.total < dealer.total
      puts "Dealer has higher total than #{player.name}. Dealer wins!"
      player.money -= player.bet
    elsif player.total == dealer.total
      puts "It's a tie!"  
    end
  end

  def new_game
    place_bet
    start
    begin
      if winner? == false
        hit_or_stay
      end
    end until winner? == true || @end_game == true
    winning_msg
    play_again?
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
        @end_game = false
        puts ""
        puts "Starting new game..."
        new_game
      end
    else
      puts "Thanks for playing! You're leaving with $#{player.money}."
      exit
    end
  end

  def play
    get_name
    new_game
  end

end

Game.new.play
