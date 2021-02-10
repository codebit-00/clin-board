module Requester
  # your code here
  def select_boards_option
    loop do
      display_boards_menu
      option, index = gets.chomp.split
      method = "#{option}_board".to_sym

      if %w[show update delete].include?(option) && index.nil?
        puts "WARNING: Please specify ID".red
        next
      end

      case option
      when "exit"
        save
        break
      when "create" then create_board
      when "show", "update", "delete" then send(method, index.to_i)
      end
    end
  end

  def request_new_board_info
    print "Name: ".colorize_app
    name = gets.chomp

    print "Description: ".colorize_app
    description = gets.chomp

    { name: name, description: description }
  end

  def request_new_card_info
    print "Title: "
    title = gets.chomp
    print "Members: "
    members = gets.chomp.split(", ")
    print "Labels: "
    labels = gets.chomp.split(", ")
    due_date = request_correct_date

    hash = { title: title, members: members, labels: labels, due_date: due_date }
    hash.each do |k, v|
      hash.delete(k) if v.empty?
    end

    hash
  end

  def request_correct_date
    print "Due Date: "
    due_date = gets.chomp
    until due_date =~ /20[2-9]\d-(0[1-9]|1[0-2])-([1-2]\d|3[0-1])/ || due_date.empty?
      puts "WRONG date format! (yyyy-dd-mm)".red
      print "Due Date:"
      due_date = gets.chomp
    end
    due_date
  end

  def select_lists_cards_option
    loop do
      display_lists_cards_menu
      option, arg = gets.chomp.split

      case option
      when "back" then break
      when "create-list", "update-list", "delete-list" then execute_lists_option(option, arg)
      when "create-card", "checklist", "update-card", "delete-card" then execute_cards_option(option, arg)
      else next
      end
      display_lists_table(@current_board.lists)
    end
  end

  def select_checklist_option(id)
    card = find_card(id)
    return (puts "Card does not exist") if card.nil?

    display_checklist_items(card)
    loop do
      display_checklist_options
      option, index = gets.chomp.split
      case option
      when "back" then break
      when "add" then add_checkitem(card)
      when "toggle" then toggle_checkitem(card, index.to_i)
      when "delete" then delete_checkitem(card, index.to_i)
      end
      display_checklist_items(card)
    end
  end

  def request_check_item_title
    print "Title: "
    title = gets.chomp
    { title: title }
  end

  def request_new_list_info
    print "Name: ".colorize_app
    name = gets.chomp

    { name: name }
  end
end

module CRUD
  def execute_lists_option(option, listname)
    if %w[update-list delete-list].include?(option) && listname.nil?
      puts "WARNING: Please insert FILENAME".red
      return
    end

    case option
    when "create-list" then create_list
    when "update-list" then update_list(listname)
    when "delete-list" then delete_list(listname)
    end
  end

  def create_list
    @current_board.lists << List.new(**request_new_list_info)
  end

  def update_list(listname)
    list = find_list(listname)

    if list.nil?
      puts "List was not found".red
      return
    end

    list.name = request_new_list_info[:name]
  end

  def delete_list(listname)
    list = find_list(listname)

    if list.nil?
      puts "List was not found".red
      return
    end

    @current_board.lists.delete(list)
  end

  def execute_cards_option(option, id)
    if %w[checklist update-card delete-card].include?(option) && id.nil?
      puts "WARNING: Please insert ID".red
      return
    end

    case option
    when "create-card" then create_card
    when "checklist" then select_checklist_option(id.to_i)
    when "update-card" then update_card(id.to_i)
    when "delete-card" then delete_card(id.to_i)
    end
  end

  def create_card
    print "Select a list: \n"\
          "#{@current_board.lists.map(&:name).join(' | ')}\n"\
          "> "
    list = find_list(gets.chomp)
    if list
      list.cards << Card.new(request_new_card_info)
    else
      puts "Abort, wrong listname provided".red
    end
  end

  def update_card(id)
    card = find_card(id)

    if card.nil?
      puts "Card was not found".red
      return
    end

    card.update_info(request_new_card_info)
  end

  def delete_card(id)
    card = find_card(id)

    if card.nil?
      puts "Card was not found".red
      return
    end

    list = @current_board.lists.find { |l| l.cards.include?(card) }
    list.cards.delete(card)
  end

  def add_checkitem(card)
    card.checklist << CheckItem.new(**request_check_item_title)
  end

  def toggle_checkitem(card, index)
    card.checklist[index - 1].toggle
  end

  def delete_checkitem(card, index)
    card.checklist.delete_at(index - 1)
  end
end
