namespace :notifications do
  desc 'Load notifications from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/notifications.yml"
    if File.exists? file_path
      puts 'Deleting old notifications...'
      Notification.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          notification = Notification.new id: id
          notification.assign_attributes data
          notification.save!
          print "\r#{id}    "
        end
        puts
      end
      Notification.connection.execute "select setval('notifications_id_seq', (select max(id) from notifications));"
      puts "Done. We have #{Notification.count} notifications now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump notifications to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/notifications.yml"
    ignored   = %w(id)
    File.open file_path, 'w' do |file|
      Notification.order('id asc').each do |entity|
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
