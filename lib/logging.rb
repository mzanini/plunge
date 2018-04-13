module Logging
  def log
    Logging.log
  end

  def self.set_logger(logger)
    @logger = logger
  end

  def self.log
    @logger ||= Logger.new(STDOUT)
  end
end