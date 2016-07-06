namespace :comments do
  desc 'Import comments from YAML with deleting old data'
  task import: :environment do
    file_path = "#{Rails.root}/tmp/import/comments.yml"
    if File.exists? file_path
      puts 'Deleting old comments...'
      Comment.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          comment = Comment.new id: id
          comment.assign_attributes data
          comment.save!
          print "\r#{id}    "
        end
        puts
      end
      Comment.connection.execute "select setval('comments_id_seq', (select max(id) from comments));"
      puts "Done. We have #{Comment.count} comments now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Export comments to YAML'
  task export: :environment do
    file_path = "#{Rails.root}/tmp/export/comments.yml"
    ignored   = %w(id ip)
    File.open file_path, 'w' do |file|
      Comment.order('id asc').each do |comment|
        print "\r#{comment.id}    "
        file.puts "#{comment.id}:"
        comment.attributes.reject { |attribute| ignored.include? attribute }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
        file.puts "  ip: #{comment.ip}" unless comment.ip.blank?
      end
      puts
    end
  end
end
