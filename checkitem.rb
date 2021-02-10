class CheckItem
  attr_reader :title

  def initialize(title:, completed: false)
    @title = title
    @completed = completed
  end

  def toggle
    @completed = @completed ? false : true
  end

  def completed?
    @completed
  end

  def show_status
    @completed ? "[X]" : "[ ]"
  end

  def to_hash
    { title: @title, completed: @completed }
  end
end
