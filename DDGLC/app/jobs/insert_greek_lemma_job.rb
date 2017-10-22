require 'csv'

class InsertGreekLemmaJob < ApplicationJob
  include InsertJob

  def perform(path)
    @msgs = []
    CSV.foreach path do |row|
      next if row.blank?
      insert_lemma(row)
      insert_lemma_comment(row)
    end
    insert_exceptions
    File.open('migrate_logs.txt','w') do |f|
      f.puts @msgs
    end
  end

  def insert_lemma(row)

    values = read_row(row)
    return if values.empty?
    id = values[:id]
    values.except! :id
    lemma = Lemma.create_with(values).find_or_create_by!(id: id)
    if lemma.save!
      @msgs << "INFO \t Saved lemma!"
    else
      @msgs << "WARNING \t Could not save lemma!"
    end
  rescue StandardError => e
    @msgs << "ERROR \t #{e.message} in"
    @msgs << "\t\t #{row.to_s}"
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
  end

  def insert_lemma_comment(row)
    id = row[3]
    read_comments(row).each do |comment_data|
      comment_data[:lemma_id] = id
      comment_data[:created_by] = User.find_by_code('Admin') if comment_data[:created_by].nil?
      comment_data[:updated_by] = User.find_by_code('Admin')
      lemma_comment = LemmaComment.find_or_create_by!(comment_data)
      if lemma_comment.save!
        @msgs << "INFO \t Saved lemma comment !"
      else
        @msgs << "WARNING \t Could not save lemma comment!"
      end
    end
  rescue StandardError => e
    @msgs << "ERROR \t #{e.message} in"
    @msgs << "\t\t #{row.to_s}"
  end

  def read_comments(data)
    comments = []
    language_comment = data[12]
    comments = add_comment(comments, 'loan_word_form', language_comment)
    reference_comment = data[15]
    comments = add_comment(comments, 'reference', reference_comment)
    lemma_comment = data[16]
    comments = add_comment(comments, 'lemma', lemma_comment)
    processing_comment = data[27]
    comments = add_comment(comments, 'processing_note', processing_comment)
    comments
  end

  def add_comment(comments, field, content)
    return comments if content.blank?
    content.squish!
    raise "Comment is too long for #{field}" if content.length > 650
    if content =~ /^[A-Z][a-z][A-Z][a-z][:]?/
      user_code = content[0..3]
      content = content[5..-1].squish
      user = User.find_by_code(user_code)
    end
    comments << {field: field, content: content, created_by: user}
  end




  def article(values, field_value)
    return values if field_value.blank?

    field_value = field_value.nil? ? nil : field_value.squish
    articles = ['ὁ', 'τώ', 'οἱ', 'ἡ', 'τά', 'αἱ', 'τό', 'ὁ / ἡ']
    raise "Cannot find article" unless articles.include? field_value

    values[:article] = field_value
    values
  end

  def semantic_field(values, field_value)
    return values if field_value.blank?

    field_value = field_value.nil? ? nil : field_value.squish
    f = SemanticField.find_by_label(field_value)
    raise "Cannot find semantic field" if f.nil?
    values[:semantic_fields] << f
    values
  end

  def user(values, field_key, field_value)
    raise "User cannot be empty" if field_value.blank?
    field_value = 'Admin' if field_value.eql? 'SU'

    field_value = field_value.nil? ? nil : field_value.squish
    user = User.create_with(
             email: 'ddglc@uni-leipzig.de',
             role: 'guest',
             password: 'ddglc123',
             password_confirmation: 'ddglc123'
          ).find_or_create_by!(code: field_value)
    values[field_key] = user
    values
  end

  def date(values, field_key, field_value)
    field_value = field_value.nil? ? nil : field_value.squish
    values[field_key] = Time.parse(field_value)
    values
  end

  def insert_exceptions

    semantic_fields1 = [SemanticField.find_by_label("Social and political relations"), SemanticField.find_by_label("Gesellschaft und Gemeinschaft")]
    exception1_lemma = {id: 6105, label: 'παρρησίᾳ', part_of_speech: PartOfSpeech.find_by_label('adverb'),
                        meaning: 'freely', source: 'DMT I', reference: 'cf. LSJ 1344a, s.v. παρρησία',
                        created_by: User.find_by_code('MaBr'), created_at: Time.parse('17.04.2013 14:48:06'),
                        updated_by: User.find_by_code('GuSp'), updated_at: Time.parse('22.02.2016 10:04:21'),
                        semantic_fields: semantic_fields1}
    exception1_comment1 = {lemma_id: 6105, field: 'part_of_speech', content: 'dative form of noun'}
    exception1_comment2 = {lemma_id: 6105, field: 'lemma', content: 'DMB: cf. adverbial use with a Coptic grammatical morph in lemma 1684.'}

    semantic_fields2 = [SemanticField.find_by_label("The physical world"), SemanticField.find_by_label("Anorganische Welt. Stoffe")]
    exception2_lemma = {id: 5548, label: 'φύσει', part_of_speech: PartOfSpeech.find_by_label('adverb'),
                        meaning: 'naturally', source: 'du Cange 1712',
                        created_by: User.find_by_code('Admin'), created_at: Time.parse('01.02.2013 07:07:48'),
                        updated_by: User.find_by_code('DyBu'), updated_at: Time.parse('16.04.2014 15:33:15'),
                        semantic_fields: semantic_fields2}
    exception2_comment1 = {lemma_id: 5548, field: 'part_of_speech', content: 'dative of φύσις'}

    semantic_fields3 = [SemanticField.find_by_label("Possession"), SemanticField.find_by_label("Wirtschaft")]
    exception3_lemma = {id: 5130, label: 'ἰνδικτίωνος', part_of_speech: PartOfSpeech.find_by_label('noun'),
                        meaning: 'of or belonging to the indiction', source: 'Lantschoot 1929', reference: 'du Cange 1712',
                        loan_word_form: 'indictio', language: Language.find_by_code('lat'),
                        created_by: User.find_by_code('Admin'), created_at: Time.parse('01.02.2013 07:07:47'),
                        updated_by: User.find_by_code('DyBu'), updated_at: Time.parse('06.09.2016 15:57:39'),
                        semantic_fields: semantic_fields3}
    exception3_comment1 = {lemma_id: 5130, field: 'part_of_speech', content: 'or adjective'}
    exception3_comment2 = {lemma_id: 5130, field: 'lemma', content: 'Cf. lemma 956.', created_by: User.find_by_code('MaBr')}

    lemma_data = [exception1_lemma, exception2_lemma, exception3_lemma]
    comment_data = [exception1_comment1, exception1_comment2, exception2_comment1, exception3_comment1, exception3_comment2]

    lemma_data.each do |data|
      id = data[:id]
      data.except! :id
      lemma = Lemma.create_with(data).find_or_create_by!(id: id)
      if lemma.save!
        @msgs << "INFO \t Saved lemma -- Exception!"
      else
        @msgs << "WARNING \t Could not save lemma -- Exception!"
      end
    end

    comment_data.each do |data|
      data[:created_by] = User.find_by_code('Admin') if data[:created_by].nil?
      data[:updated_by] = User.find_by_code('Admin')
      lemma_comment = LemmaComment.find_or_create_by!(data)
      if lemma_comment.save!
        @msgs << "INFO \t Saved lemma comment -- Exception!"
      else
        @msgs << "WARNING \t Could not save lemma comment -- Exception!"
      end
    end

  rescue StandardError => e
    @msgs << "ERROR \t #{e.message} (Exception) in"
    @msgs << "\t\t #{row.to_s}"
  end
end