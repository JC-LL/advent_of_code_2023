puts IO.readlines(ARGV.first).map(&:chomp).map{|line|
  digits=line.scan(/\d/)
  [digits.first,digits.last].join.to_i
}.sum
