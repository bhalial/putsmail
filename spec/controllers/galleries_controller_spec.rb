require "spec_helper"

describe GalleriesController do
  
  let(:test_mail) { double "Test Mail" }
  let(:public_mails) { double "Public Mails" }

  before { TestMail.stub(public_mails: public_mails) }

  describe "#index" do
    it "loads all test_mails" do
      public_mails.should_receive(:all)
      get "index"
    end
  end

  describe "#show" do
    it "loads test_mail" do
      public_mails.should_receive(:find).with "0"
      get "show", id: 0
    end

    it "renders show with no layout" do
      public_mails.stub :find
      get "show", id: 0
      expect(response).to render_template(:show, layout: false)
    end
  end
end
