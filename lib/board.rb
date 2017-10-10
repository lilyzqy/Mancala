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
    if start_pos <= 0 || start_pos > 13
      raise ArgumentError.new("Invalid starting cup")
    end
  end

  def make_move(start_pos, current_player_name)
    stones = @cups[start_pos].length
    @cups[start_pos] = []
    stones.times do |i|
      next_pos = start_pos + 1 + i
      if (current_player_name == @name1 && next_pos == 13)||
        (current_player_name == @name2 && next_pos == 6)
        i += 1
        next
      end
      @cups[next_pos] << :stone
    end
    ending_cup_idx = start_pos + stones
    render
    next_turn(ending_cup_idx,current_player_name)
  end

  def next_turn(ending_cup_idx,current_player_name)
    return :switch if @cups[ending_cup_idx] == 1
    return :prompt if (current_player_name == @name1 && ending_cup_idx == 6)||
(current_player_name == @name2 && ending_cup_idx == 13)
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
