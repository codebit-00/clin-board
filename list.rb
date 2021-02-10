class List
  attr_accessor :name, :cards

  @@id = 0

  def initialize(name:, cards: [], **rest)
    @rest = rest # shut up rubocop!
    @id = next_id
    @@id = @if if @id > @@id
    @name = name
    @cards = cards
  end

  def next_id
    @@id += 1
  end

  def to_hash
    { id: @id, name: @name, cards: @cards.map(&:to_hash) }
  end

  def check_how_many_cards
    output = []
    @cards.each do |card|
      last_word = card.name.split(" ").last
      output << card.name.gsub(last_word, last_word).to_s
    end
    output.join(", ")
  end
end
