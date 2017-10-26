require 'csv'

class InsertUsageJob < ApplicationJob
  include InsertJob

  def perform(path)
    @msgs = []
    CSV.foreach path, headers: true do |row|
      next if row.blank?
      # insert_usage(row)
      insert_usage_comment(row)
    end
    insert_exceptions
    File.open('migrate_logs_usage.txt','w') do |f|
      f.puts @msgs
    end
  end

  def insert_usage(row)
    return if row.empty?

    values = read_row row
    values[:sublemma] = find_sublemma row
    id = values[:id]
    values.except! :id
    usage = Usage.create_with(values).find_or_create_by!(id: id)
    if usage.save!
      @msgs << "INFO \t Saved usage!"
    else
      @msgs << "WARNING \t Could not save usage!"
    end
  rescue StandardError => e
    @msgs << "ERROR \t #{e.message} in"
    # @msgs << e.backtrace.join("\n")
    @msgs << "\t\t #{row.to_s}"
  end

  def find_sublemma(row)
    values = {}
    values = pos(values, row['coptic_usage::cl_type'])
    values = sublemma_hierarchy(values, row['coptic_usage::cu_cl_hiera'])
    values = normalize_field(values, :label, row['coptic_usage::cl_lemma'])
    values = language(values, row['coptic_usage::cl_donorlang'])
    sublemma = Sublemma.find_by(values)
    raise 'Cannot find sublemma' if sublemma.nil?
    sublemma
  end

  def read_row(row)
    values = {}
    values = normalize_field values, :id, row['coptic_usage::cu_ID']
    values = normalize_field values, :coptic_specification, row['coptic_usage::cu_copticspec']
    values = normalize_field values, :meaning, row['coptic_usage::cl_meaning']
    values = usage_hierarchy values, row['coptic_usage::cu_hierarchy']
    values = distinction_tier values, row['coptic_usage::cu_distlabel']
    values = criterion values, row['coptic_usage::cu_criterion']
    values = corresponding_usages values, row['coptic_usage::cu_encylremark']
    values = usage_categories values, row['coptic_usage::cu_label']
    values = user values, :created_by, row['coptic_usage::cl_entered_who']
    values = user values, :updated_by, row['coptic_usage::cl_changed_who']
    values = date values, :created_at, row['coptic_usage::cl_entered']
    values = date values, :updated_at, row['coptic_usage::cl_changed']
    values
  end

  def usage_categories(values, field_value)
    return values if field_value.blank?

    categories = []
    codes = field_value.delete('[').delete(']').tr(',;', '#').split('#').map(&:squish)
    codes.each do |c|
      category = UsageCategory.find_by_code(c)
      raise 'Cannot find usage category' if category.nil?
      categories << category
    end
    values[:usage_categories] = categories unless categories.empty?
    values
  end

  # TODO: there is also comment in this field!
  def corresponding_usages(values, field_value)
    return values if field_value.blank? || !field_value.downcase.include?('corresponding usage')

    usages = []
    data = field_value.delete(',').split('#')
    puts "after split: #{data}"
    (1..data.size-1).to_a.each do |i|
      id = data[i].squish.to_i
      next if id.zero?
      usages << id
    end
    values[:corresponding_usages] = usages
    values
  end

  def criterion(values, field_value)
    return values if field_value.blank?

    criterion = field_value.squish[1..(field_value.length - 2)]
    values[:criterion] = criterion
    values
  end

  def distinction_tier(values, field_value)
    return values if field_value.blank? || field_value.eql?('TBD')

    field_value.gsub! 'syntagm.:', 'syntagmatic: '
    field_value.gsub! 'pos', 'part of speech'

    tier = DistinctionTier.where("label LIKE '%#{field_value[0..(field_value.length-2)]}%'").first
    raise 'Cannot find distinction tier' if tier.nil?
    values[:distinction_tier] = tier
    values
  end

  def usage_hierarchy(values, field_value)
    return values if field_value.blank?

    levels = field_value.squish.split('.')
    levels[0] = levels[0].upcase
    levels[1] = levels[1].downcase if levels.size >= 2
    if levels.size >= 3
      levels[2] =
        if levels[2].eql? '1'
          'i'
        elsif levels[2].eql? '2'
          'ii'
        elsif levels[2].eql? '3'
          'iii'
        else
          levels[2].downcase
        end
    end
    field_value = levels.join('.')
    values[:hierarchy] = field_value
    values
  end

  def insert_usage_comment(row)
    return if row.empty?

    id = row['coptic_usage::cu_ID']
    read_comments(row).each do |comment_data|
      comment_data[:usage_id] = id
      comment_data[:created_by] = User.find_by_code('Admin') if comment_data[:created_by].nil?
      comment_data[:updated_by] = User.find_by_code('Admin')
      usage_comment = UsageComment.find_or_create_by!(comment_data)
      if usage_comment.save!
        @msgs << "INFO \t Saved usage comment !"
      else
        @msgs << "WARNING \t Could not save usage comment!"
      end
    end
  rescue StandardError => e
    @msgs << "ERROR \t #{e.message} in"
    @msgs << "\t\t #{row.to_s}"
  end

  def read_comments(row)
    comments = []
    comments = add_comment comments, 'encylremark', row['coptic_usage::cu_encylremark']
    comments = add_comment comments, 'general', row['coptic_usage::cl_comment']
    comments = add_comment comments, 'delete', row['coptic_usage::cl_delete_comment']
    comments = add_comment comments, 'processing_note', row['coptic_usage::cl_procNote']
    comments
  end

  def insert_exceptions

  end

end
