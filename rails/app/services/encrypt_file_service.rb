module EncryptFileService
  extend self

  def encrypt(source:, dest:, key:)
    data = ''
    File.open(source, 'r') do |t|
      data = t.read
    end

    encrypted_data = self.encrypt_data(data: data, key: key)
    encoded_data = Base64.encode64(encrypted_data).encode('utf-8')

    File.open(dest, 'w') do |file|
      file.puts(encoded_data)
    end
  end


  # db_path = Rails.configuration.database_configuration[ENV['RAILS_ENV']]['database']
  # EncryptFileService.decrypt(
  #   source: File.expand_path('db/enc'),
  #   dest: File.expand_path(db_path),
  #   key: jwt_decode.first['key']
  # )
  def decrypt(source:, dest:, key:)
    encoded_data = ''
    File.open(source, 'r') do |t|
      encoded_data = t.read
    end
    decoded_data = Base64.decode64(encoded_data)

    decrypted_data = self.decrypt_data(encrypted_data: decoded_data, key: key)

    File.open(dest, 'wb') do |file|
      file.puts(decrypted_data)
    end
  end

  def check_key(path:, key:)
    encoded_data = ''
    File.open(path, 'r') do |t|
      encoded_data = t.read
    end
    decoded_data = Base64.decode64(encoded_data)
    data = self.decrypt_data(encrypted_data: decoded_data, key: key)
    return false unless data

    true
  end

  def delete(path)
    File.delete(path)
  end

  private
    def encrypt_data(data:, key:)
      enc = OpenSSL::Cipher.new('AES-256-CBC')
      enc.encrypt
      enc.key = key

      encrypted_data = ''
      encrypted_data << enc.update(data)
      encrypted_data << enc.final
    end

    def decrypt_data(encrypted_data:, key:)
      dec = OpenSSL::Cipher.new('AES-256-CBC')
      dec.decrypt
      dec.key = key

      data = ''
      data << dec.update(encrypted_data)
      data << dec.final
    end

end
