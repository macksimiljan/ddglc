require 'csv'

class InsertCopticSublemmaJob < ApplicationJob
  include InsertJob

  def perform(path)
    @admin = User.find_by_code('Admin')
    @msgs = []
    CSV.foreach path do |row|
      next if row.blank?
      insert_sublemma(row)
    end
    # insert_exceptions
    File.open('migrate_logs_sublemma.txt', 'w') do |f|
      f.puts @msgs
    end
  end

  def insert_sublemma(row)
    values = read_row(row)
    return if values.empty?
    id = row[7]
    values[:created_by] = @admin
    values[:updated_by] = @admin
    lemma = Sublemma.create_with(values).find_or_create_by!(id: id)
    if lemma.save!
      @msgs << "INFO \t Saved sublemma!"
    else
      @msgs << "WARNING \t Could not save sublemma!"
    end
  rescue StandardError => e
    @msgs << "ERROR \t #{e.message} in"
    # @msgs << e.backtrace.join("\n")
    @msgs << "\t\t #{row.to_s}"
  end

  def read_row(data)
    values = {}
    values = normalize_field(values, :label, data[3])
    values = pos(values, data[1])
    values = normalize_field(values, :loaned_form, data[5])
    values = hierarchy(values, data[2])
    values = language(values, data[4])
    values = lemma(values, data[6])
    values
  end

  def hierarchy(values, field_value)
    return values if field_value.blank?

    values[:hierarchy] = field_value.squish.upcase
    values
  end

  def lemma(values, field_value)
    return values if field_value.blank?

    l = Lemma.find_by_id(field_value.squish)
    raise 'Cannot find lemma id' if l.nil?
    values[:lemma] = l
    values
  end
end