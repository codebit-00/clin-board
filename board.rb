class Board
  attr_accessor :id, :name, :description, :lists

  @@id = 0

  def initialize(name:, description:, lists: [], **rest)
    @rest = rest # usless asignment, jsut to make rubocop stfu
    @id = next_id
    @@id = @if if @id > @@id
    @name = name
    @description = description
    @lists = lists
  end

  def next_id
    @@id += 1
  end

  def to_hash
    { id: @id, name: @name, description: @description, lists: @lists.map(&:to_hash) }
  end

  def check_how_many_lists
    output = []
    @lists.each do |list|
      last_word = list.name.split(" ").last
      output << "#{list.name.gsub(last_word, last_word)}(#{list.cards.size})"
    end
    output.join(", ")
  end
end
