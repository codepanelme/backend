
class Log
  @@instance ||= Logger.new(STDOUT)

  def self.debug(msg)
    return if test?
    @@instance.debug(msg)
  end

  def self.info(msg)
    return if test?
    @@instance.info(msg)
  end

  def self.warn(msg)
    return if test?
    @@instance.warn(msg)
  end

  def self.test?
    ENV['APP_ENVIRONMENT'] == 'test'
  end

  private_class_method :new
end
