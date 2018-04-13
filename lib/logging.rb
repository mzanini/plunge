module Logging
  def log
    Logging.log
  end

  def self.log
    @logger ||= Logger.new(STDOUT)
  end
end