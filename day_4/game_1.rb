require_relative "../debug"
Card=Struct.new(:id,:winning,:actual)

def parse filename
  IO.readlines(filename).map.with_index do |line,idx|
    id,data=line.split(':')
    id=id.scan(/\d+/).first
    win,actual=data.split('|').map(&:split)
    win=win.map(&:to_i)
    actual=actual.map(&:to_i)
    Card.new(id,win,actual)
  end
end

def count_winning cards
  cards.map{|card|
    ary=card.actual.intersection(card.winning)
    value(ary)
  }.sum
end

def value ary
  p ary.inject(1){|accu,e| accu*=2}/2
end

filename=ARGV.first
pp cards=parse(filename)
pp count_winning(cards)
