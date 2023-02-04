require 'digest'
require 'pp'
require 'pry'

class Block
  attr_reader :index, :timestamp, :data, :previous_hash, :nonce, :hash

  DIFFICULTY = '00'

  def initialize(index, data, previous_hash)
    @index = index
    @timestamp = Time.now
    @data = data
    @previous_hash = previous_hash
    @nonce, @hash = compute_hash_with_proof_of_work
  end

  def compute_hash_with_proof_of_work(difficulty = DIFFICULTY)
    nonce = 0
    sha = Digest::SHA256.new

    loop do
      hash = calc_hash_with_nonce(sha, nonce)
      return [nonce, hash] if hash.start_with?(difficulty)

      nonce += 1
    end
  end

  def calc_hash_with_nonce(sha, nonce = 0)
    sha.reset
    sha.update(nonce.to_s + @index.to_s + @timestamp.to_s + @data.to_s + @previous_hash)
    sha.hexdigest
  end

  def self.first(data = "Genesis")
    Block.new(0, data, "0")
  end

  def self.next(previous, data = "transaction or something")
    Block.new(previous.index + 1, data, previous.hash)
  end
end

# Example data. Please use console command & enjoy ~> ruby block.rb 

b0 = Block.first("First block")
b1 = Block.next(b0, "Buy crypto")
b2 = Block.next(b1, "Sold crypto")
b3 = Block.next(b2, "Transaction completed")

blockchain = [b0, b1, b2, b3]
pp blockchain