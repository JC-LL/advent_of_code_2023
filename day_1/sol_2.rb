# attention, il ne suffit pas de faire un scan, car
# il peut y avoir des overlapp comme oneight => 1,8
# ca m'a joué des tours !
digits_h={one:1,two:2,three:3,four:4,five:5,six:6,seven:7,eight:8,nine:9}

sum=IO.readlines(ARGV.first).map(&:chomp).map{|line|
  digits=[]
  while line.size != 0
    digits_h.each do |str,val|
      if line.match /\A(#{str}|#{val})/
        digits << val.to_s
      end
    end
    line=line[1..-1] #shift
  end
  [digits.first,digits.last].join.to_i
}.sum

puts "sum=#{sum}"
