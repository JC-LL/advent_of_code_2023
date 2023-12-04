require_relative "../debug"

Card=Struct.new(:id,:winning,:actual,:nb_win)

def parse filename
  hash={}
  IO.readlines(filename).each do |line|
    id,data=line.split(':')
    id=id.scan(/\d+/).first.to_i
    win,actual=data.split('|').map(&:split)
    win=win.map(&:to_i)
    actual=actual.map(&:to_i)
    hash[id]=Card.new(id,win,actual)
  end
  hash
end

def count_winning
  @cards_h.values.each do |card|
    ary=card.actual.intersection(card.winning)
    card.nb_win=ary.size
  end
end

def process hand
  hand.map{|card| earn_rec(card)}.flatten
end

def earn_rec card,level=0
  earned=[]
  card.nb_win.times do |i|
    earned << next_card=@cards_h[card.id+i+1]
    earned << earn_rec(next_card,level+1)
    earned.flatten!
  end
  earned
end

@cards_h=parse(filename=ARGV.first)
count_winning

hand=@cards_h.values
earned=process(hand)

puts "nb card at start : #{p1=hand.size}"
puts "nb card won      : #{p2=earned.size}"
puts "total            : #{p1+p2}"
