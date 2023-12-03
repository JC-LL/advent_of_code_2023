filename=ARGV.first

Game=Struct.new(:id,:plays)
Play=Struct.new(:nb,:color)

def parse filename
  games=[]
  IO.readlines(filename).each_with_index do |line,idx|
    game=Game.new(idx+1,[])
    _,plays=line.split(':')
    plays.split(';').each do |play|
      colors_h=play.split(',').map do |nb_color|
        mdata=nb_color.match(/ (?<nb>\d+) (?<color>.*)/)
        [mdata[:color].to_sym,mdata[:nb].to_i]
      end.to_h
      game.plays << colors_h
    end
    games << game
  end
  games
end

constraints={
  red:   12,
  green: 13,
  blue:  14
}

legal_games=[]

sum=parse(filename).map.with_index do |game,idx|
  [:red,:green,:blue].map{|color| game.plays.map{|play| play[color]}.compact.max}.inject(:*)
end.sum

puts sum
