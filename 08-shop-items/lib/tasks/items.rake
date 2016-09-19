require 'fileutils'

namespace :items do
  desc 'Load items from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/items.yml"
    image_dir = "#{Rails.root}/tmp/import/items"
    if File.exists? file_path
      puts 'Deleting old items...'
      Item.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          attributes = data.reject { |key| %w(image).include? key }
          item       = Item.new id: id
          item.assign_attributes attributes
          if data.has_key? 'image'
            image_file = "#{image_dir}/#{id}/#{data['image']}"
            item.image = Pathname.new(image_file).open if File.exists?(image_file)
          end
          item.save!
          print "\r#{id}    "
        end
        puts
      end
      Item.connection.execute "select setval('items_id_seq', (select max(id) from items));"
      puts "Done. We have #{Item.count} items now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump items to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/items.yml"
    image_dir = "#{Rails.root}/tmp/export/items"
    ignored   = %w(id image comments_count)
    Dir.mkdir image_dir unless Dir.exists? image_dir
    File.open file_path, 'w' do |file|
      Item.order('id asc').each do |entity|
        print "\r#{entity.id}    "
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
        unless entity.image.blank?
          image_name = File.basename(entity.image.path)
          Dir.mkdir "#{image_dir}/#{entity.id}" unless Dir.exists? "#{image_dir}/#{entity.id}"
          FileUtils.copy entity.image.path, "#{image_dir}/#{entity.id}/#{image_name}"
          file.puts "  image: #{image_name.inspect}"
        end
      end
      puts
    end
  end
end
