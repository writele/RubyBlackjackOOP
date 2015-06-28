#Blackjack is a card game with a Dealer and Players. The Dealer deals two cards to themselves and the player. The Dealer's top card is hidden. 
#If the Player or Dealer has a face card and an ace, they automatically win.
#Aces are worth 1 or 11. If value goes over 21, aces are changed to value of 1.
#The Player chooses to Hit or Stay. Hit, the dealer deals a card. Stay, the turn moves to the Dealer.
#A player busts (loses) if their cards > 21. The player wins if the cards == 21.
#The dealer deals themselves a card until they reach the value of 17. If the cards == 21, Dealer wins. If cards > 21, Dealer busts, Player wins.
#If neither Dealer or Player has won or lost, the hand with the greater value wins.


class Deck
  attr_accessor :cards
  
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

  def deal_card
    this_card = cards.pop
    puts this_card
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

deck = Deck.new
puts deck.cards.size
deck.deal_card
puts deck.cards.size

# class Hand
#   attr_accessor :cards

#   def inititalize
#     @cards = []
#   end

#   def score
#     arr = @cards.map{|e| e[1]}

#     total = 0
#     arr.each do |value|
#       if value == "Ace"
#         total += 11
#       elsif value.to_i == 0
#         total += 10
#       else
#         total += value.to_i
#       end
#     end

#     arr.select{|e| e == "Ace"}.count.times do
#       if total > 21
#         total -= 10
#       end
#     end

#     total

#   end

# end


# Player
#   hand = Hand.new
#   score


# Dealer
#   hand = Hand.new
#   score = hand.score


# Hand
#   initialize
#   cards = []
#   deal_card * 2

#   score

#   display


# Game 

#   play
#     deck = Deck.new
#     Player.hand.display
#     Dealer.hand.display
#     Player move (hit)
#     Dealer move (stay)


#     Hit
#       deal a card
#       add to player score
#       dislay hand

#     Stay
#       deal a card
#       add to dealer score
#       display hand

