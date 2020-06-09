class ScheduledMessage < ApplicationRecord
  belongs_to :created_by, :class_name => "Employee", :foreign_key => "created_by_id", optional: true
  enum frequency_type: [:no, :weekly, :monthly, :annually]
  enum status: [:inactive, :active, :executed, :canceled]
  validates_inclusion_of :repeat, in: ->(sm) { sm.allowed_repeats }, message: "%{value} is not included in the list"
  before_save :set_next_execution
  before_validation :default_values

  def allowed_repeats
    case frequency_type
    when "weekly"
      ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    when "monthly"
      ["first_day", "last_day"] + (1..31).to_a.map { |i| i.to_s }
    when "annually"
      ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]
    else
      [""]
    end
  end

  def default_values
    self.frequency = self.frequency || 1
    self.status = self.status || "active"
  end

  def next_date
    if !self.no?
      date = get_date(self.frequency)
      actualDate = starts_at > Date.today ? starts_at : Date.today
      count = 0
      freq = self.frequency
      while date < actualDate
        count += 1
        date = get_date(freq)
        freq += 1
        return if count > 1000
      end
      return if self.finished_at && self.finished_at < date
      date
    else
      self.starts_at && self.starts_at >= Date.today ? self.starts_at + 1 : nil
    end
  end

  def get_date(freq)
    case self.frequency_type
    when "no"
      Date.today + 1.day
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
    if self.executed? && self.starts_at_changed? && self.starts_at >= Date.today
      self.status = "active"
      self.next_execution = next_date
    end
    if self.active?
      if self.finished_at && self.finished_at < Date.today && self.last_execution.to_s.empty?
        self.next_execution = nil
        if self.last_execution
          self.status = "executed"
        elsif self.no?
          SendSmsWorker.perform_async(self.id) if Log::Worker.where("name = 'SendSmsWorker' and finished_at is null and created_at = ? and content->'scheduled_message'->>'id' = ?", Date.today, self.id.to_s).empty?
        end
        return
      end
    end
    if self.active?
      if self.starts_at_changed? || self.last_execution_changed? || self.frequency_type_changed? || self.frequency_changed? || self.repeat_changed?
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
