DIRECTIONS=[[ 0,-1],[ 0,+1],[+1, 0],[-1, 0],[+1,-1],[-1,-1],[+1,+1],[-1,+1]]

class Grid
  def [](x,y)
    return nil unless x<@dim and y<@dim
    @tab[y][x]
  end

  def []=(x,y,val)
    @tab[y][x]=val
  end

  def fill filename
    lines=IO.readlines(filename).map(&:chomp)
    @dim=lines.size
    @tab=Array.new(@dim){Array.new(@dim)}
    lines.each_with_index do |line,row|
      line.chars.each_with_index do |char,col|
        self[col,row]=char
      end
    end
  end

  def draw
    @dim.times do |y|
      @dim.times do |x|
        print self[x,y]
      end
      puts
    end
  end

  def analyze
    detect_numbers
    check
  end

  def detect_numbers
    @pos_numbers=[] #array of hash of pos => number
    for y in 0..@dim-1
      number=[]
      for x in 0..@dim-1
        if (char=self[x,y]).match /\d/
          number << char
        else
          if number.any?
            range=(x-number.size)..(x-1)
            @pos_numbers << {number.join => [range,y]}
          end
          number=[]
        end
      end
      # this case was missing !
      if number.any?
        range=(x-number.size)..(x-1)
        @pos_numbers << {number.join => [range,y]}
      end
    end
  end

  def check
    symbols=[]
    total=0
    @pos_numbers.each do |hash|
      num,ary=hash.first
      range,y=ary
      first,last=range.first,range.last
      legality=false
      neighbor=nil
      for x in first..last
        DIRECTIONS.each do |dx,dy|
          neighbor=self[x+dx,y+dy]
          if neighbor and neighbor.match(/[^\d\.]/)
            legality=true
          end
        end
      end
      puts "#{num} at #{range},#{y} : #{legality ? "symbol '#{neighbor}' found" : "NO symbol found"}"
      total+=num.to_i if legality
    end
    puts "total=#{total}"
  end
end

filename=ARGV.first
grid=Grid.new
grid.fill filename
grid.draw
grid.analyze
