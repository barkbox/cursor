require 'cursor/models/active_record_model_extension'

module CursorInheritance
  def inherited(kls)
    super kls
    kls.send(:include, Cursor::ActiveRecordModelExtension) if kls.superclass == ::ActiveRecord::Base
  end
end

module Cursor
  module ActiveRecordExtension
    extend ActiveSupport::Concern
    included do
      prepend CursorInheritance

      # Existing subclasses pick up the model extension as well
      self.descendants.each do |kls|
        kls.send(:include, Cursor::ActiveRecordModelExtension) if kls.superclass == ::ActiveRecord::Base
      end
    end
  end
end
