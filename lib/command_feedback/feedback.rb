require "httparty"


module CommandFeedback
  class Service
    def self.get_feedback title, choices, description = ""
      service = Service.new title, choices, description
      service.process
    end

    def initialize title, choices, description
      body = { 
        "multiplechoice" => {
          "title" => title,
          "description" => description,
          "choices" => Service.build_choices_hash(choices)
        } 
      }
      options = { :headers => { 'ContentType' => 'application/json' } }

      @response = HTTParty.post "http://localhost:3000/questions.json", :body => body, :options => options
    end

    def self.build_choices_hash(choices)
      choices_hash = {}
      choices.each_with_index { |choice, index|
        choices_hash["choice_#{index + 1}"] = choice
      }
      choices_hash
    end

    def process
      if was_successful?
        SuccessfulFeedback.new(@response["question"])
      else
        ErrorFeedback.new(@response["errors"])
      end
    end

    def was_successful?
      @response.include? "question" and
        @response["question"].include? "admin_link" and
        @response["question"].include? "feedback_link"
    end

    class ErrorFeedback
      attr_reader :errors

      def initialize(error_data)
        @errors = []
        error_data.each { |attribute, errors|
          errors.each { |error|
            @errors << "#{attribute} #{error}"
          }
        }
      end

      def successfull?
        false
      end
    end

    class SuccessfulFeedback
      attr_reader :admin_link, :feedback_link

      def initialize(data_json)
        @admin_link = data_json["admin_link"]
        @feedback_link = data_json["feedback_link"]
      end

      def successfull?
        true
      end
    end
  end
end
