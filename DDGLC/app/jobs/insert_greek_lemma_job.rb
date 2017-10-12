require 'csv'

class InsertGreekLemmaJob < ApplicationJob

  def perform(path)
    CSV.foreach path do |row|
      insert_lemma(row)
    end
  end

  def insert_lemma(row)
    values = read_row(row)
    lemma = Lemma.create(values)
    if lemma.save!
      puts "Saved lemma!"
    else
      puts "Could not save lemma!"
    end
  end

  def read_row(data)
    values = {}
    values[:id] = data[3]
    raise 'ID is null!' if values[:id].blank?
    values = normalize_field(values, :label, data[2])
    values = pos(values, data[4])
    values = article(values, data[5])
    values = normalize_field(values, :meaning, data[6])
    values = normalize_field(values, :loan_word_form, data[8])
    values = language(values, data[10])
    values = normalize_field(values, :source, data[13])
    values = normalize_field(values, :reference, data[14])
    values[:semantic_fields] = []
    values = semantic_field(values, data[17])
    values = semantic_field(values, data[18])
    values = semantic_field(values, data[19])
    values = semantic_field(values, data[20])
    values = semantic_field(values, data[21])
    values = semantic_field(values, data[22])
    values = user(values, :created_by, data[23])
    values = date(values, :created_at, data[24])
    values = user(values, :updated_by, data[25])
    values = date(values, :updated_at, data[26])
    values
  rescue Exception => e
    puts "ERROR \t #{e.message} in:"
    puts data.to_s
  end


  def normalize_field(values, field_key, field_value, isOptional=true)
    return values if field_value.blank? && isOptional
    raise "Obligatory field is empty" if field_value.blank? && !isOptional
    values[field_key] = field_value.squish
    values
  end

  def pos(values, field_value)
    pos = PartOfSpeech.find_by_label(field_value.squish)
    raise "Cannot find POS" if pos.nil?
    values[:part_of_speech] = pos
    values
  end

  def article(values, field_value)
    return values if field_value.blank?

    articles = ['ὁ', 'τώ', 'οἱ', 'ἡ', 'τά', 'αἱ', 'τό', 'ὁ / ἡ']
    raise "Cannot find article" unless articles.include? field_value.squish

    values[:article] = field_value.squish
    values
  end

  def language(values, field_value)
    return values if field_value.blank?

    lang = Language.find_by_code(field_value.squish)
    raise "Cannot find language" if lang.nil?
    values[:language] = lang
    values
  end

  def semantic_field(values, field_value)
    return values if field_value.blank?

    f = SemanticField.find_by_label(field_value.squish)
    raise "Cannot find semantic field" if f.nil?
    values[:semantic_fields] << f
    values
  end

  def user(values, field_key, field_value)
    raise "User cannot be empty" if field_value.blank?
    user = User.create_with(
             email: 'ddglc@uni-leipzig.de',
             role: 'guest',
             password: 'ddglc123',
             password_confirmation: 'ddglc123'
          ).find_or_create_by!(code: field_value.squish)
    values[field_key] = user
    values
  end

  def date(values, field_key, field_value)
    values[field_key] = Time.parse(field_value.squish)
    values
  end

  def insert_comments(data)
    # TODO: implement me
  end
end