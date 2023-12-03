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

  def solve
    find_numbers_by_row
    find_star_positions
    compute_gears
  end

  def find_numbers_by_row
    @nums_in_row={}
    @dim.times do |y|
      @nums_in_row[y]=[]
      number=[]
      for x in 0..@dim-1
        if (char=self[x,y]).match /\d/
          number << char
        elsif number.any? #end of number
          range=(x-number.size)..(x-1)
          @nums_in_row[y] << {number.join => range}
          number=[]
        end
      end
      if number.any? #end of number
        range=(x-number.size)..(x-1)
        @nums_in_row[y] << {number.join => range}
      end
    end
  end

  def find_star_positions
    @star_positions=[]
    @dim.times do |y|
      @dim.times do |x|
        @star_positions << [x,y] if self[x,y]=='*'
      end
    end
  end

  def compute_gears
    sum=0
    @star_positions.each do |x,y|
      gear_candidates=find_numbers_ajacent_to(x,y)
      if gear_candidates.size==2
        ratio=gear_candidates.inject(:*)
        sum+=ratio
      end
    end
    puts sum
  end

  def find_numbers_ajacent_to x,y
    nums=[]
    DIRECTIONS.each do |dx,dy|
      posx,posy=x+dx,y+dy
      if (row=posy) < @dim
        @nums_in_row[row].each do |num_range_h|
          num,range=num_range_h.first
          if range.include?(posx)
            nums << num.to_i
          end
        end
      end
    end
    nums.uniq #play with luck !
  end
end

grid=Grid.new
grid.fill filename=ARGV.first
grid.solve
