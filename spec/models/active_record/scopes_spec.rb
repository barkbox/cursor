require 'spec_helper'

if defined? ActiveRecord

  describe Cursor::ActiveRecordModelExtension do
    before do
      Cursor.configure do |config|
        config.page_method_name = :per_page_cursor
      end
      class Comment < ActiveRecord::Base; end
    end

    subject { Comment }
    it { should respond_to(:per_page_cursor) }
    it { should_not respond_to(:page) }

    after do
      Cursor.configure do |config|
        config.page_method_name = :page
      end
    end
  end

  shared_examples_for 'the first after page' do
    it { should have(25).users }
    its('first.name') { should == 'user001' }
  end

  shared_examples_for 'the first before page' do
    it { should have(25).users }
    its('first.name') { should == 'user100' }
  end


  shared_examples_for 'blank page' do
    it { should have(0).users }
  end

  describe Cursor::ActiveRecordExtension do
    before do
      1.upto(100) {|i| User.create! :name => "user#{'%03d' % i}", :age => (i / 10)}
      1.upto(100) {|i| GemDefinedModel.create! :name => "user#{'%03d' % i}", :age => (i / 10)}
      1.upto(100) {|i| Device.create! :name => "user#{'%03d' % i}", :age => (i / 10)}
    end

    [User, Admin, GemDefinedModel, Device].each do |model_class|
      context "for #{model_class}" do
        describe '#page' do
          context 'page 1 after' do
            subject { model_class.page(after: 0) }
            it_should_behave_like 'the first after page'
          end

          context 'page 1 before' do
            subject { model_class.page(before: 101) }
            it_should_behave_like 'the first before page'
          end

          context 'page 2 after' do
            subject { model_class.page(after: 25) }
            it { should have(25).users }
            its('first.name') { should == 'user026' }
          end

          context 'page 2 before' do
            subject { model_class.page(before: 75) }
            it { should have(25).users }
            its('first.name') { should == 'user074' }
          end

          context 'page without an argument' do
            subject { model_class.page() }
            it_should_behave_like 'the first before page'
          end

          context 'after page < -1' do
            subject { model_class.page(after: -1) }
            it_should_behave_like 'the first after page'
          end

          context 'after page > max page' do
            subject { model_class.page(after: 1000) }
            it_should_behave_like 'blank page'
          end

          context 'before page < 0' do
            subject { model_class.page(before: 0) }
            it_should_behave_like 'blank page'
          end

          context 'before page > max page' do
            subject { model_class.page(before: 1000) }
            it_should_behave_like 'the first before page'
          end


          describe 'ensure #order_values is preserved' do
            subject { model_class.order('id').page() }
            its('order_values.uniq') { should == ["#{model_class.table_name}.id desc"] }
          end
        end

        describe '#per' do
          context 'default page per 5' do
            subject { model_class.page.per(5) }
            it { should have(5).users }
            its('first.name') { should == 'user100' }
          end

          context "default page per nil (using default)" do
            subject { model_class.page.per(nil) }
            it { should have(model_class.default_per_page).users }
          end
        end

        describe '#next_cursor' do

          context 'after 1st page' do
            subject { model_class.page(after: 0) }
            its(:next_cursor) { should == 25 }
          end

          context 'after middle page' do
            subject { model_class.page(after: 50) }
            its(:next_cursor) { should == 75 }
          end

          context 'before 1st page' do
            subject { model_class.page }
            its(:next_cursor) { should == 76}
          end

          context 'before middle page' do
            subject { model_class.page(before: 50) }
            its(:next_cursor) { should == 25}
          end

        end

        describe '#prev_cursor' do
          context 'after 1st page' do
            subject { model_class.page(after: 0) }
            its(:prev_cursor) { should == 1}
          end

          context 'after middle page' do
            subject { model_class.page(after: 50) }
            its(:prev_cursor) { should == 51 }
          end

          context 'before 1st page' do
            subject { model_class.page }
            its(:prev_cursor) { should == 100}
          end

          context 'before middle page' do
            subject { model_class.page(before: 50) }
            its(:prev_cursor) { should == 49}
          end
        end
      end
    end
  end
end
