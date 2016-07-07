require 'fileutils'

namespace :users do
  desc 'Import users from YAML with deleting old data'
  task import: :environment do
    file_path = "#{Rails.root}/tmp/import/users.yml"
    image_dir = "#{Rails.root}/tmp/import/users"
    if File.exists? file_path
      puts 'Deleting old users...'
      User.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          attributes = data.reject { |key| %w(image roles).include? key }
          user       = User.new id: id
          user.assign_attributes attributes
          if data.has_key? 'image'
            image_file = "#{image_dir}/#{data['image']}"
            user.image = Pathname.new(image_file).open if File.exists?(image_file)
          end
          user.save!

          if data.has_key? 'roles'
            data['roles'].each { |role| user.add_role role }
          end
          print "\r#{id}    "
        end
        puts
      end
      User.connection.execute "select setval('users_id_seq', (select max(id) from users));"
      puts "Done. We have #{User.count} users now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Export users to YAML'
  task export: :environment do
    file_path = "#{Rails.root}/tmp/export/users.yml"
    image_dir = "#{Rails.root}/tmp/export/users"
    ignored   = %w(id image ip)
    Dir.mkdir image_dir unless Dir.exists? image_dir
    File.open file_path, 'w' do |file|
      User.order('id asc').each do |user|
        print "\r#{user.id}    "
        file.puts "#{user.id}:"
        user.attributes.reject { |attribute| ignored.include? attribute }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
        file.puts "  ip: #{user.ip}" unless user.ip.blank?
        unless user.image.blank?
          image_name = File.basename(user.image.path)
          FileUtils.copy user.image.path, "#{image_dir}/#{image_name}"
          file.puts "  image: #{image_name.inspect}"
        end
        if user.user_roles.any?
          roles = user.user_roles.map { |link| link.role }
          file.puts "  roles: #{roles.inspect}"
        end
      end
      puts
    end
  end
end