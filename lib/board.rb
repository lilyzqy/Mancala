class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @name1,@name2 = name1,name2
    @cups = Array.new(14){[]}.each_with_index do |cup,i|
      unless i == 6 || i == 13
        cup.concat([:stone, :stone, :stone, :stone])
      end
    end
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
  end

  def valid_move?(start_pos)
    if start_pos < 0 || start_pos > 12 || @cups[start_pos].empty?
      raise ArgumentError.new("Invalid starting cup")
    end
  end

  def make_move(start_pos, current_player_name)
    stones = @cups[start_pos]
    ending_cup_idx = start_pos + stones.length
    @cups[start_pos] = []
    cup_idx = start_pos
    until stones.empty?
      cup_idx += 1
      cup_idx = 0 if cup_idx > 13

      if cup_idx == 6
        if current_player_name == @name1
          @cups[cup_idx] << stones.pop
        end

      elsif cup_idx == 13
        if current_player_name == @name2
          @cups[cup_idx] << stones.pop
        end
      else
        @cups[cup_idx] << stones.pop
      end
    end
    render
    next_turn(cup_idx,current_player_name)
  end

  def next_turn(ending_cup_idx,current_player_name)
    return :prompt if (current_player_name == @name1 && ending_cup_idx == 6)||
(current_player_name == @name2 && ending_cup_idx == 13)
    return :switch if @cups[ending_cup_idx].length == 1
    return ending_cup_idx
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups.take(6).all?{|cup| cup.empty?} || @cups[7..12].all?{|cup| cup.empty?}
  end

  def winner
    case @cups[13].count <=> @cups[6].count
    when 0
      return :draw
    when 1
      return @name2
    when -1
      return @name1
    end
  end
end
