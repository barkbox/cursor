require 'active_support/configurable'

module Cursor
  # Configures global settings for Cursor
  #   Cursor.configure do |config|
  #     config.default_per_page = 10
  #   end
  def self.configure(&block)
    yield config
  end

  # Global settings for Cursor
  def self.config
    @config ||= Cursor::Configuration.new
  end

  # need a Class for 3.0
  class Configuration #:nodoc:
    include ActiveSupport::Configurable

    config_accessor :default_per_page do
      25
    end
    config_accessor :max_per_page do
      nil
    end
    config_accessor :page_method_name do
      :cursor
    end
    config_accessor :before_param_name do
      :before
    end
    config_accessor :after_param_name do
      :after
    end

    def before_param_name
      config.before_param_name.respond_to?(:call) ? config.before_param_name.call : config.before_param_name
    end

    def after_param_name
      config.after_param_name.respond_to?(:call) ? config.after_param_name.call : config.after_param_name
    end
  end
end
