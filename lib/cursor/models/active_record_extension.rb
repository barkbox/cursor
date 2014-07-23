require 'cursor/models/active_record_model_extension'

module Cursor
  module ActiveRecordExtension
    extend ActiveSupport::Concern
    included do
      # Future subclasses will pick up the model extension
      class << self
        def inherited_with_cursor(kls) #:nodoc:
          inherited_without_cursor kls
          kls.send(:include, Cursor::ActiveRecordModelExtension) if kls.superclass == ::ActiveRecord::Base
        end
        alias_method_chain :inherited, :cursor
      end

      # Existing subclasses pick up the model extension as well
      self.descendants.each do |kls|
        kls.send(:include, Cursor::ActiveRecordModelExtension) if kls.superclass == ::ActiveRecord::Base
      end
    end
  end
end
