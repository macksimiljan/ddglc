namespace :db do
  namespace :fixtures do
    desc 'Create YAML test fixtures from data in an existing database.
          Defaults to development database.  Set RAILS_ENV to override.'
    task :dump => :environment do

      skip_tables = ["schema_migrations", "ar_internal_metadata"]
      Dir.mkdir("#{Rails.root}/test/fixtures_dump") unless File.exists?("#{Rails.root}/test/fixtures_dump")

      ActiveRecord::Base.establish_connection(:development)
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
        i = "000"

        # Make order of output more deterministic
        sql  = "SELECT * FROM %s"
        column_names =  ActiveRecord::Base.connection.columns(table_name).map(&:name)
        if column_names.include?('id')
          sql << ' ORDER BY id ASC'
        elsif column_names.select{|column_name| column_name.match(/.*_id\Z/)}.present?
          other_id_columns = column_names.select{|column_name| column_name.match(/.*_id\Z/)}.sort
          other_id_sql = other_id_columns.map{|cn| "#{cn} ASC"}
          sql << " ORDER BY #{other_id_sql.join(', ')}"
        else
          sql << " ORDER BY #{column_names.sort.first} ASC"
        end

        File.open("#{Rails.root}/test/fixtures_dump/#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.execute(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.to_yaml
        end
      end
    end
  end
end
