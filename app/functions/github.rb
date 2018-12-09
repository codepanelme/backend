require './app/models/github_event'
require './app/lib/log'

module Webhooks
  class Github
    def self.handler(event:, context:)
      Log.info "Webhook triggered: #{event}"

      if Webhooks::GithubEvent.build(event).save!
        {
          statusCode: 200,
          body: JSON.generate(message: 'Github Event successfully created')
        }
      else
        {
          statusCode: 500,
          body: JSON.generate(message: 'Unable to create Github Event')
        }
      end
    end
  end
end
