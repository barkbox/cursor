module Cursor
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'cursor' do |_app|
      Cursor::Hooks.init
    end
  end
end
