require 'spec_helper'

describe FileClip::Validators do
  let(:image) { Image.new }

  describe "validations" do
    before :each do
      Image.reset_callbacks(:validate)
      Image._validators.clear
    end

    describe "if no filepicker_url" do
      it "observes attachment presence" do
        Image.validates :attachment, :attachment_presence => true
        image.save.should be_false
        image.errors.first.last.should == "can't be blank"
      end

      it "observes attachment size" do
        Image.validates_attachment :attachment, :size => { :in => 0..1000 }, :presence => true
        image.save.should be_false
        image.errors.should_not be_empty
      end

      it "observes attachment content" do
        Image.validates_attachment :attachment, :content_type => { :content_type => "image/jpg" }, :presence => true
        image.save.should be_false
        image.errors.should_not be_empty
      end
    end

    describe "with filepicker url" do
      before :each do
        image.filepicker_url = "image.com"
        image.filepicker_url_not_present?.should be_false
      end

      it "observes attachment presence" do
        pending
        Image.validates :attachment, :attachment_presence => true
        image.save.should be_true
        image.errors.should be_empty
      end

      it "observes attachment size" do
        Image.validates_attachment :attachment, :size => { :in => 0..1000 }, :presence => true
        image.save.should be_true
        image.errors.should be_empty
      end

      it "observes attachment content" do
        Image.validates_attachment :attachment, :content_type => { :content_type => "image/jpg" }, :presence => true
        image.save.should be_true
        image.errors.should be_empty
      end
    end

    describe "for non fileclipped asset" do
      let(:asset) { Asset.new }

      before :each do
        Asset.reset_callbacks(:validate)
        Asset._validators.clear
      end

      describe "if no filepicker_url" do
        it "observes attachment presence" do
          Asset.validates :attachment, :attachment_presence => true
          asset.save.should be_false
          asset.errors.first.last.should == "can't be blank"
        end

        it "observes attachment size" do
          Asset.validates_attachment :attachment, :size => { :in => 0..1000 }, :presence => true
          asset.save.should be_false
          asset.errors.should_not be_empty
        end

        it "observes attachment content" do
          Asset.validates_attachment :attachment, :content_type => { :content_type => "image/jpg" }, :presence => true
          asset.save.should be_false
          asset.errors.should_not be_empty
        end
      end
    end
  end
end