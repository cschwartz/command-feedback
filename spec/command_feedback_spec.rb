require "spec_helper"

include CommandFeedback

describe Service do
  describe "calls out to the REST api" do
    it "successfull" do
      VCR.use_cassette "successfull" do
        feedback = Service.get_feedback "A title", ["Choice 1", "Choice 2"], "A Description"
        expect(feedback.successfull?).to eq(true)
        expect(feedback.admin_link).to eq("http://get-feedback.at/questions/7-admin-RR12")
        expect(feedback.feedback_link).to eq("http://get-feedback.at/answers/new.7-RR12")
      end
    end

    it "unsuccessfull, too short title" do
      VCR.use_cassette "unsuccessfull-title" do
        feedback = Service.get_feedback "A", ["Choice 1", "Choice 2"], "A Description"
        expect(feedback.successfull?).to eq(false)
        expect(feedback.errors).to include('title is too short (minimum is 4 characters)')
      end
    end

    it "unsuccessfull, not enough choices" do
      VCR.use_cassette "unsuccessfull-choices" do
        feedback = Service.get_feedback "A title", ["Choice 1"], "A Description"
        expect(feedback.successfull?).to eq(false)
        expect(feedback.errors).to include('choices must contain at least two items.')
      end
    end

  end

    it "builds a choices hash" do
    choices = ["a", "b"]
    expect(Service.build_choices_hash(choices)).to eq({"choice_1" => "a", "choice_2" => "b"})
  end
end
