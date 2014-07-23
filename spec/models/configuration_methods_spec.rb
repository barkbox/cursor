require 'spec_helper'

describe "configuration methods" do
  let(:model){ User }

  describe "#default_per_page" do
    if defined? ActiveRecord
      describe 'AR::Base' do
        subject { ActiveRecord::Base }
        it { should_not respond_to :paginates_per }
      end
    end

    subject { model.page() }

    context "by default" do
      its(:limit_value){ should == 25 }
    end

    context "when configuring both on global and model-level" do
      before do
        Cursor.configure {|c| c.default_per_page = 50 }
        model.paginates_per 100
      end

      its(:limit_value){ should == 100 }
    end

    context "when configuring multiple times" do
      before do
        Cursor.configure {|c| c.default_per_page = 10 }
        Cursor.configure {|c| c.default_per_page = 20 }
      end

      its(:limit_value){ should == 20 }
    end

    after do
      Cursor.configure {|c| c.default_per_page = 25 }
      model.paginates_per nil
    end
  end

  describe "#max_per_page" do
    if defined? ActiveRecord
      describe 'AR::Base' do
        subject { ActiveRecord::Base }
        it { should_not respond_to :max_pages_per }
      end
    end

    subject { model.page.per(1000) }

    context "by default" do
      its(:limit_value){ should == 1000 }
    end

    context "when configuring both on global and model-level" do
      before do
        Cursor.configure {|c| c.max_per_page = 50 }
        model.max_paginates_per 100
      end

      its(:limit_value){ should == 100 }
    end

    context "when configuring multiple times" do
      before do
        Cursor.configure {|c| c.max_per_page = 10 }
        Cursor.configure {|c| c.max_per_page = 20 }
      end

      its(:limit_value){ should == 20 }
    end

    after do
      Cursor.configure {|c| c.max_per_page = nil }
      model.max_paginates_per nil
    end
  end

end
