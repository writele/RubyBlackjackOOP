#Blackjack is a card game with a Dealer and Players. The Dealer deals two cards to themselves and the player. The Dealer's top card is hidden. 
#If the Player or Dealer has a face card and an ace, they automatically win.
#Aces are worth 1 or 11. If value goes over 21, aces are changed to value of 1.
#The Player chooses to Hit or Stay. Hit, the dealer deals a card. Stay, the turn moves to the Dealer.
#A player busts (loses) if their cards > 21. The player wins if the cards == 21.
#The dealer deals themselves a card until they reach the value of 17. If the cards == 21, Dealer wins. If cards > 21, Dealer busts, Player wins.
#If neither Dealer or Player has won or lost, the hand with the greater value wins.


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
      if total > 21
        total -= 10
      end
    end

    total

  end

end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = []
  end

end


class Dealer < Player
end

class Game

  def initialize
    @deck = Deck.new
    @player = Player.new(" ")
    @dealer = Dealer.new("Dealer")
    @stay = false

  end

  def get_name
    @player.name = gets.chomp
  end

  def start
    puts "Welcome to Blackjack! What's your name?"
    get_name
    puts "Dealing cards..."
    @dealer.deal_card(@deck.top_card)
    @dealer.deal_card(@deck.top_card)
    @player.deal_card(@deck.top_card)
    @player.deal_card(@deck.top_card)
    @dealer.show_hand
    @player.show_hand
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
    @player.deal_card(@deck.top_card)
    @player.show_hand
  end

  def stay
    begin
      @dealer.deal_card(@deck.top_card)
      @dealer.show_hand
    end until @dealer.total > 17
    @stay = true
  end

  def winner?
    if @player.total == 21 || @dealer.total == 21 || @player.total > 21 || @dealer.total > 21
      return true
    else
      return false
    end
  end

  def winning_msg

    if @player.total == 21 && @dealer.total == 21
      puts "#{@player.name} and dealer are tied!"
    elsif @player.total > 21
      puts "#{@player.name} busts! Dealer wins!"
    elsif @player.total == 21
      puts "#{@player.name} has 21! #{@player.name} wins!"
    elsif @dealer.total == 21
      puts "Dealer has 21! Dealer wins!" 
    elsif @dealer.total > 21
      puts "Dealer busts! #{@player.name} wins!"
    elsif @player.total > @dealer.total
      puts "#{@player.name} has higher total than dealer. #{@player.name} wins!"
    elsif @player.total < @dealer.total
      puts "Dealer has higher total than #{@player.name}. Dealer wins!"
    elsif @player.total == @dealer.total
      puts "It's a tie!"  
    end

  end

  def play

    start
    begin
      if winner? == false
        hit_or_stay
      end
    end until winner? == true || @stay == true
    winning_msg
  end

end

Game.new.play
