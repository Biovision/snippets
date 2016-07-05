namespace :tokens do
  desc 'Import tokens from YAML with deleting old data'
  task import: :environment do
    file_path = "#{Rails.root}/tmp/import/tokens.yml"
    if File.exists? file_path
      puts 'Deleting old tokens...'
      Token.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          token = Token.new id: id
          token.assign_attributes data
          token.save!
          print "\r#{id}    "
        end
        puts
      end
      Token.connection.execute "select setval('tokens_id_seq', (select max(id) from tokens));"
      puts "Done. We have #{Token.count} tokens now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Export tokens to YAML'
  task export: :environment do
    file_path = "#{Rails.root}/tmp/export/tokens.yml"
    ignored   = %w(id ip)
    File.open file_path, 'w' do |file|
      Token.order('id asc').each do |token|
        print "\r#{token.id}    "
        file.puts "#{token.id}:"
        token.attributes.reject { |attribute| ignored.include? attribute }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
        file.puts "  ip: #{token.ip}" unless token.ip.blank?
      end
      puts
    end
  end
end
