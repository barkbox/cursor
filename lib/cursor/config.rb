require 'active_support/configurable'

module Cursor
  # Configures global settings for Cursor
  #   Cursor.configure do |config|
  #     config.default_per_page = 10
  #   end
  def self.configure(&block)
    yield @config ||= Cursor::Configuration.new
  end

  # Global settings for Cursor
  def self.config
    @config
  end

  # need a Class for 3.0
  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :default_per_page
    config_accessor :max_per_page
    config_accessor :page_method_name
    config_accessor :before_param_name
    config_accessor :after_param_name

    def before_param_name
      config.before_param_name.respond_to?(:call) ? config.before_param_name.call : config.before_param_name
    end

    def after_param_name
      config.after_param_name.respond_to?(:call) ? config.after_param_name.call : config.after_param_name
    end


    # define param_name writer (copied from AS::Configurable)
    writer, line = 'def before_param_name=(value); config.before_param_name = value; end', __LINE__
    singleton_class.class_eval writer, __FILE__, line
    class_eval writer, __FILE__, line

    writer, line = 'def after_param_name=(value); config.after_param_name = value; end', __LINE__
    singleton_class.class_eval writer, __FILE__, line
    class_eval writer, __FILE__, line

  end

  # this is ugly. why can't we pass the default value to config_accessor...?
  configure do |config|
    config.default_per_page = 25
    config.max_per_page = nil
    config.page_method_name = :page
    config.before_param_name = :before
    config.after_param_name = :after
  end
end
