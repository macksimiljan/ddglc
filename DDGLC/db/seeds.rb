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
              'noun', 'participle', 'particle', 'particle: discourse', 'particle: interrogative',
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

lwt_fields = {  :'http://wold.clld.org/semanticfield/1' => 'The physical world',
                :'http://wold.clld.org/semanticfield/2' => 'Kinship',
                :'http://wold.clld.org/semanticfield/3' => 'Animals',
                :'http://wold.clld.org/semanticfield/4' => 'The body',
                :'http://wold.clld.org/semanticfield/5' => 'Food and drink',
                :'http://wold.clld.org/semanticfield/6' => 'Clothing and grooming',
                :'http://wold.clld.org/semanticfield/7' => 'The house',
                :'http://wold.clld.org/semanticfield/8' => 'Agriculture and vegetation',
                :'http://wold.clld.org/semanticfield/9' => 'Basic actions and technology',
                :'http://wold.clld.org/semanticfield/10' => 'Motion',
                :'http://wold.clld.org/semanticfield/11' => 'Possession',
                :'http://wold.clld.org/semanticfield/12' => 'Spatial relations',
                :'http://wold.clld.org/semanticfield/13' => 'Quantity',
                :'http://wold.clld.org/semanticfield/14' => 'Time',
                :'http://wold.clld.org/semanticfield/15' => 'Sense perception',
                :'http://wold.clld.org/semanticfield/16' => 'Emotions and values',
                :'http://wold.clld.org/semanticfield/17' => 'Cognition',
                :'http://wold.clld.org/semanticfield/18' => 'Speech and language',
                :'http://wold.clld.org/semanticfield/19' => 'Social and political relations',
                :'http://wold.clld.org/semanticfield/20' => 'Warfare and hunting',
                :'http://wold.clld.org/semanticfield/21' => 'Law',
                :'http://wold.clld.org/semanticfield/22' => 'Religion and belief',
                :'http://wold.clld.org/semanticfield/23' => 'Modern world',
                :'http://wold.clld.org/semanticfield/24' => 'Miscellaneous function words'
}
lwt_fields.each_pair do |url, label|
  SemanticField
    .create_with(url: url, source: 'LWT')
    .find_or_create_by!(label: label)
end

dornseiff_fields = ['Anorganische Welt. Stoffe', 'Das Denken', 'Fühlen. Affekte. Charaktereigenschaften',
                    'Geräte. Technik', 'Gesellschaft und Gemeinschaft', 'Größe. Menge. Zahl. Grad',
                    'Kunst', 'Ortsveränderung', 'Pflanze. Tier. Mensch (Körperliches)', 'Raum. Lage. Form',
                    'Recht. Ethik', 'Religion. Das Übersinnliche', 'Schrifttum. Wissenschaft',
                    'Sichtbarkeit. Licht. Farbe. Schall. Temperatur. Gewicht. Aggregatzustände. Geruch. Geschmack',
                    'Sinnesempfindungen', 'Wesen. Beziehung. Geschehnis.', 'Wirtschaft', 'Wollen und Handeln',
                    'Zeichen. Mitteilung. Sprache', 'Zeit']
dornseiff_fields.each do |label|
  SemanticField
    .create_with(source: 'Dornseiff')
    .find_or_create_by!(label: label)
end

distinction_tiers = ['lexicalisation', 'morphological', 'syntagmatic: function', 'syntagmatic: part of speech',
                     'syntagmatic: valency', 'semantic', 'pragmatic']
distinction_tiers.each do |tier|
  DistinctionTier.find_or_create_by!(label: tier)
end

usage_categories = ['alch.', 'arch.', 'astrol.', 'bibl.', 'biol.', 'bot.',
                    'eccl.', 'epist.', 'gen.', 'geog.', 'homil.', 'leg.',
                    'lit.', 'liturg.', 'mag.', 'mart.', 'med.', 'metaph.',
                    'mil.', 'mon.', 'num.', 'phil.', 'phsy.', 'poet.', 'theol.']
usage_categories.each do |category|
  UsageCategory.find_or_create_by!(code: category)

end


User.create_with(email: 'ddglc@uni-leipzig.de',
                 role: 'admin',
                 password: 'foobar',
                 password_confirmation: 'foobar')
    .find_or_create_by!(code: 'TeSt')