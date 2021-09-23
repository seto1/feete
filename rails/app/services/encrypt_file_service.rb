module EncryptFileService
  extend self

  def encrypt(source:, dest:, key:)
    data = ''
    File.open(source, 'r') do |t|
      data = t.read
    end

    enc = OpenSSL::Cipher.new('AES-256-CBC')
    enc.encrypt
    enc.key = key
    encrypted_data = ''
    encrypted_data << enc.update(data)
    encrypted_data << enc.final
    encoded_data = Base64.encode64(encrypted_data).encode('utf-8')

    File.open(dest, 'w') do |file|
      file.puts(encoded_data)
    end
  end

  def delete(path)
    File.delete(path)
  end

end
