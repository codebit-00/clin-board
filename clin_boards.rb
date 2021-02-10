require_relative "formatter"
require_relative "requester"
require_relative "board"
require_relative "list"
require_relative "card"
require_relative "checkitem"
require "json"

class ClinBoards
  include Formatter
  include Requester
  include CRUD

  def initialize(filename)
    # Complete this
    @filename = filename
  end

  def start
    # Complete this
    display_welcome_message
    json_parser
    display_boards_table
    select_boards_option

    # display_lists_table @lists

    display_goodbye_message
  end

  def json_parser
    @boards = JSON.parse(File.read(@filename), symbolize_names: true)
    @boards.map! do |board|
      board[:lists].map! do |list|
        list[:cards].map! do |card|
          card[:checklist].map! do |checkitem|
            CheckItem.new(**checkitem)
          end
          Card.new(**card)
        end
        List.new(**list)
      end
      Board.new(**board)
    end
  end

  def find_list(name)
    @current_list = @current_board.lists.find { |list| list.name == name }
  end

  def find_card(id)
    @current_board.lists.each do |list|
      result = list.cards.find { |card| card.id == id }
      return result if result
    end
    nil
  end

  private

  def create_board
    # TODO: assign some ID to object...
    @boards << Board.new(request_new_board_info)
    display_boards_table
  end

  def update_board(id)
    board = @boards.find { |b| b.id == id }
    if board.nil?
      puts "Board does not exist".red
    else
      updated_info = request_new_board_info
      board.name = updated_info[:name] unless updated_info[:name].empty?
      board.description = updated_info[:description] unless updated_info[:description].empty?
      display_boards_table
    end
  end

  def delete_board(id)
    board = @boards.find { |b| b.id == id }
    if @boards.delete board
      display_boards_table
      puts "Board(ID:#{id}) was deleted".yellow
    else
      puts "Board(ID:#{id}) doesn't exist".red
    end
  end

  def show_board(id)
    @current_board = @boards.find { |b| b.id == id }
    if @current_board
      display_lists_table(@current_board.lists)
      select_lists_cards_option
      display_boards_table # as in display the boards table again when the user exits the lists tables
    else
      puts "Board(ID:#{id}) doesn't exist".red
    end
  end

  def save
    File.write(@filename, JSON.dump(@boards.map(&:to_hash)))
  end
end

filename = ARGV.shift || "store.json"

app = ClinBoards.new filename
app.start
