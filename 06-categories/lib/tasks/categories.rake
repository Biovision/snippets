namespace :categories do
  desc 'Load categories from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/categories.yml"
    if File.exists? file_path
      puts 'Deleting old categories...'
      Category.destroy_all
      puts 'Done. Loading...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          category = Category.new id: id
          category.assign_attributes data
          category.save!
          print "\r#{id}    "
        end
        puts
      end
      Category.connection.execute "select setval('categories_id_seq', (select max(id) from categories));"
      puts "Done. We have #{Category.count} categories now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump categories to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/categories.yml"
    ignored   = %w(id items_count)
    File.open file_path, 'w' do |file|
      Category.order('id asc').each do |entity|
        print "\r#{entity.id}    "
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
      end
      puts
    end
  end
end
