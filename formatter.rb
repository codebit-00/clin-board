require "colorize"
require "terminal-table"

module Formatter
  # your code here
  def display_welcome_message
    puts "####################################\n"\
         "#      Welcome to CLIn Boards      #\n"\
         "####################################"
  end

  def display_goodbye_message
    puts "####################################\n"\
         "#   Thanks for using CLIn Boards   #\n"\
         "####################################".colorize_app
  end

  # boards table
  def display_boards_table
    rows = []
    @boards.each do |board|
      rows << [board.id, board.name, board.description, board.check_how_many_lists]
    end
    headings = ["ID", "Name", "Description", "List(#card)"]
    table = Terminal::Table.new title: "CLIn Boards", headings: headings, rows: rows
    puts table.to_s.colorize_app
  end

  def display_boards_menu
    print "Board options: create | show ID | update ID | delete ID\n"\
          "exit\n"\
          "> ".colorize_app
  end

  # lists table

  def display_lists_table(lists)
    lists.each do |list|
      rows = []
      list.cards.each do |card|
        rows << card.to_array
      end
      headings = %w[ID Title Members Labels Due\sDate Checklist]
      table = Terminal::Table.new title: list.name, headings: headings, rows: rows
      puts table.to_s.colorize_app
    end
  end

  def display_lists_cards_menu
    print "List options: create-list | update-list LISTNAME | delete-list LISTNAME\n"\
          "Card options: create-card | checklist ID | update-card ID | delete-card ID\n"\
          "back\n"\
          "> ".colorize_app
  end

  # checklist table
  def display_checklist_items(card)
    message = "Card: #{card.title}\n"
    card.checklist.each.with_index do |checkitem, i|
      message << "#{checkitem.show_status} #{i + 1}. #{checkitem.title}\n"
    end
    message << "-------------------------------------"
    puts message.colorize_app
  end

  def display_checklist_options
    print "Checklist options: add | toggle INDEX | delete INDEX\n"\
         "back\n"\
         "> ".colorize_app
  end
end

class String
  def colorize_app
    gsub!(%r{[-+/|>:]}, &:cyan)
    gsub!(/back|ID|JSON|LISTNAME/, &:yellow)
    gsub!(/for|delete|class|if|this|with/, &:light_magenta)
    # this folowing regex will colorize:
    # any word is followed by a '('  ->  \b\w*(?=\()
    # any number not inside an encoding (eg e\[0;36;49m)  ->  (?<![\[;])\d*(?![m;])
    # TODO
    # numbers with dot infront 'n.'
    gsub!(/exit|\b\w*(?=\()|(?<![\[;])\d*(?![m;])/, &:red)
  end
end
