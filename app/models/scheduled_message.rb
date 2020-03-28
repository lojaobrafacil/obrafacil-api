class ScheduledMessage < ApplicationRecord
  belongs_to :created_by, :class_name => "Employee", :foreign_key => "created_by_id", optional: true
  enum frequency_type: [:no, :weekly, :monthly, :annually]
  enum status: [:inactive, :active, :executed, :canceled]
  validates_inclusion_of :repeat, in: ->(sm) { sm.allowed_repeats }, message: "%{value} is not included in the list"
  before_save :set_next_execution

  def allowed_repeats
    case frequency_type
    when "weekly"
      ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    when "monthly"
      ["first_day", "last_day"] + (1..31).to_a.map { |i| i.to_s }
    when "annually"
      ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]
    else
      []
    end
  end

  def next_date
    if !self.no?
      date = get_date(self.frequency)
      count = 0
      freq = self.frequency
      while date < starts_at
        count += 1
        date = get_date(freq)
        freq += 1
        return if count > 1000
      end
      return if self.finished_at && self.finished_at < date
      date
    else
      self.starts_at >= Date.today ? self.starts_at : nil
    end
  end

  def get_date(freq)
    case self.frequency_type
    when "weekly"
      Date.parse(self.repeat) + (freq * 7).day
    when "monthly"
      case self.repeat
      when "first_day"
        Date.today.at_beginning_of_month.next_month + freq.month
      when "last_day"
        Date.today.end_of_month.next_month + freq.month
      else
        (Date.today + freq.month).change(day: self.repeat)
      end
    when "annually"
      Date.parse(self.repeat) + freq.year
    else
      nil
    end
  end

  def set_next_execution
    if self.active?
      if self.finished_at < Date.today
        self.next_execution = nil
        self.status = "executed"
        return
      end
      if self.last_execution_changed?
        self.execution = self.execution + 1
        self.next_execution = next_date
        if !self.next_execution
          self.finished_at = Date.today
          self.status = "executed"
        end
      elsif !self.next_execution
        self.next_execution = next_date
      end
    end
  end
end
