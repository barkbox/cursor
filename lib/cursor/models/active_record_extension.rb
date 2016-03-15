require 'cursor/models/active_record_model_extension'

module Cursor

  module InheritedOverride
    def inherited(kls)
      inherited_without_cursor kls
      kls.send(:include, Cursor::ActiveRecordModelExtension) if kls.superclass == ::ActiveRecord::Base
    end
  end

  module ActiveRecordExtension
    extend ActiveSupport::Concern
    included do
      # Future subclasses will pick up the model extension
      self.prepend Cursor::InheritedOverride

      # Existing subclasses pick up the model extension as well
      self.descendants.each do |kls|
        kls.send(:include, Cursor::ActiveRecordModelExtension) if kls.superclass == ::ActiveRecord::Base
      end
    end
  end
end
