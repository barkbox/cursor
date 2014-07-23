require 'spec_helper'

describe Cursor::Configuration do
  subject { Cursor.config }
  describe 'default_per_page' do
    context 'by default' do
      its(:default_per_page) { should == 25 }
    end
    context 'configured via config block' do
      before do
        Cursor.configure {|c| c.default_per_page = 17}
      end
      its(:default_per_page) { should == 17 }
      after do
        Cursor.configure {|c| c.default_per_page = 25}
      end
    end
  end

  describe 'max_per_page' do
    context 'by default' do
      its(:max_per_page) { should == nil }
    end
    context 'configure via config block' do
      before do
        Cursor.configure {|c| c.max_per_page = 100}
      end
      its(:max_per_page) { should == 100 }
      after do
        Cursor.configure {|c| c.max_per_page = nil}
      end
    end
  end

  describe 'before_param_name' do
    context 'by default' do
      its(:before_param_name) { should == :before }
    end

    context 'configured via config block' do
      before do
        Cursor.configure {|c| c.before_param_name = lambda { :test } }
      end

      its(:before_param_name) { should == :test }

      after do
        Cursor.configure {|c| c.before_param_name = :before }
      end
    end
  end


  describe 'after_param_name' do
    context 'by default' do
      its(:after_param_name) { should == :after }
    end

    context 'configured via config block' do
      before do
        Cursor.configure {|c| c.after_param_name = lambda { :test } }
      end

      its(:after_param_name) { should == :test }

      after do
        Cursor.configure {|c| c.after_param_name = :after }
      end
    end
  end

end
