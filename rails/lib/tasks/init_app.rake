task :init_app, ['key'] => :environment do |task, args|
  db_path = Rails.configuration.database_configuration[ENV['RAILS_ENV']]['database']
  db_path = File.expand_path(db_path)
  unless (File.exist?(db_path))
    p 'not exist db'
  end

  begin
    EncryptFileService.encrypt(
      key: args.key,
      source: db_path,
      dest: File.expand_path('db/enc')
    )
    EncryptFileService.delete(db_path)
    p 'success'
  rescue => e
    p e.message
  end
end
