namespace :item_types do
  desc 'Load item_types from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/item_types.yml"
    if File.exists? file_path
      puts 'Deleting old item_types...'
      ItemType.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          item_type = ItemType.new id: id
          item_type.assign_attributes data
          item_type.save!
          print "\r#{id}    "
        end
        puts
      end
      ItemType.connection.execute "select setval('item_types_id_seq', (select max(id) from item_types));"
      puts "Done. We have #{ItemType.count} item_types now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump item_types to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/item_types.yml"
    ignored   = %w(id items_count)
    File.open file_path, 'w' do |file|
      ItemType.order('id asc').each do |entity|
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
