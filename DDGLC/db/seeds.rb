# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

pos_labels = ['adjective', 'adverb', 'adverbial multi-word expression', 'article',
              'conjunction', 'conjunction / adverb', 'conjunction / preposition',
              'exclamation', 'interjection', 'language island', 'nominal prefix',
              'noun', 'particle', 'particle: discourse', 'particle: interrogative',
              'preposition', 'pronoun', 'pronoun: demonstrative', 'pronoun: personal',
              'verb', 'verb: impersonal', 'word combination']
pos_labels.each do |l|
  PartOfSpeech
    .find_or_create_by!(label: l)
end

languages = { arc: 'Official Aramaic (700-300 BCE)',
              arm: nil,
              hb: nil,
              hbo: 'Ancient Hebrew',
              lat: 'Latin',
              lt: nil,
              peo: 'Old Persian (ca. 600-400BCE)'}
languages.each_pair do |code, label|
  Language
    .create_with(label: label)
    .find_or_create_by!(code: code)
end