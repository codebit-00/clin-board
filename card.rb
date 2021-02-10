class Card
  attr_accessor :title
  attr_reader :id, :members, :labels, :due_date, :checklist

  @@id = 0
  @@lists = []

  def initialize(**info)
    @id = next_id
    @@id = @id if @id > @@id
    @title = info[:title] || ""
    @members = info[:members] || []
    @labels = info[:labels] || []
    @due_date = info[:due_date] || ""
    @checklist = info[:checklist] || []
  end

  def next_id
    @@id += 1
  end

  def to_hash
    {
      id: @id,
      title: @title,
      members: @members,
      labels: @labels,
      due_date: @due_date,
      checklist: @checklist.map(&:to_hash)
    }
  end

  def to_array
    [@id, @title, @members.join(", "), @labels.join(", "), @due_date, completed_items]
  end

  def completed_items
    size = checklist.size
    completed = 0
    checklist.each { |checkitem| completed += 1 if checkitem.completed? }
    "#{completed}/#{size}"
  end

  def update_info(title: @title, members: @members, labels: @labels, due_date: @due_date)
    @title = title
    @members = members
    @labels = labels
    @due_date = due_date
  end

  def checklist_to_array_of_json
    @checklist.map(&:to_hash)
  end
end
