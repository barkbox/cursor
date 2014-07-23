module Cursor
  class Hooks
    def self.init
      ActiveSupport.on_load(:active_record) do
        require 'cursor/models/active_record_extension'
        ::ActiveRecord::Base.send :include, Cursor::ActiveRecordExtension
      end
    end
  end
end
