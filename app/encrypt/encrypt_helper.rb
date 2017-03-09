require 'openssl'
require 'digest/sha2'
require 'securerandom'

module EncryptHelper

  ALGORITHM = 'AES-256-CBC'

  def self.encrypt(file, pass_phrase)
    cipher = OpenSSL::Cipher.new(ALGORITHM)
    cipher.encrypt
    return nil if pass_phrase.nil?
    key = Digest::SHA256.hexdigest(pass_phrase)
    iv = SecureRandom.hex(32)
    cipher.key =key
    cipher.iv = iv
    File.new("#{file}.enc",File::CREAT)

    File.open("#{file}.enc", 'wb') do |enc|
      File.open(file, 'rb') do |f|
        loop do
          r = f.read(4096)
          break unless r
          temp = cipher.update(r)
          enc << temp
        end
      end
      temp = cipher.final
      enc << temp
    end
    [iv]
  end

  def self.decrypt(file,iv, pass_phrase)

    cipher = OpenSSL::Cipher.new(ALGORITHM)
    cipher.decrypt
    key = Digest::SHA256.hexdigest(pass_phrase)
    cipher.key = key
    cipher.iv = iv

    File.new("#{file}.dec",File::CREAT)
    File.open("#{file}.dec", 'wb') do |dec|
      File.open("#{file}.enc", 'rb') do |enc|
        loop do
          r = enc.read(4096)
          break unless r
          temp = cipher.update(r)
          dec << temp
        end
      end
      temp = cipher.final
      dec << temp
    end

    return compare_sha256(file, "#{file}.dec")

  end

  def self.compare_sha256(file1, file2)
    file1_sha = Digest::SHA256.hexdigest(File.open(file1, 'r'){|f| f.read})
    file2_sha = Digest::SHA256.hexdigest(File.open(file2, 'r'){|f| f.read})
    return true if file1_sha == file2_sha
    false
  end

end