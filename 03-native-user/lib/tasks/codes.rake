namespace :codes do
  desc 'Import codes from YAML with deleting old data'
  task import: :environment do
    file_path = "#{Rails.root}/tmp/import/codes.yml"
    if File.exists? file_path
      puts 'Deleting old codes...'
      Code.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          code = Code.new id: id
          code.assign_attributes data
          code.save!
          print "\r#{id}    "
        end
        puts
      end
      Code.connection.execute "select setval('codes_id_seq', (select max(id) from codes));"
      puts "Done. We have #{Code.count} codes now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Export codes to YAML'
  task export: :environment do
    file_path = "#{Rails.root}/tmp/export/codes.yml"
    ignored   = %w(id ip)
    File.open file_path, 'w' do |file|
      Code.order('id asc').each do |code|
        print "\r#{code.id}    "
        file.puts "#{code.id}:"
        code.attributes.reject { |attribute| ignored.include? attribute }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
        file.puts "  ip: #{code.ip}" unless code.ip.blank?
      end
      puts
    end
  end
end
