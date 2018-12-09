require 'spec_helper'
require './app/functions/github'

RSpec.describe Webhooks::Github do
  subject { Webhooks::Github }

  context '#handler' do
    let!(:payload) { File.new('./spec/support/fixtures/github/events/push.json').read }
    let!(:context) { {} }
    let!(:event) {
      {
        'headers' => {
          'X-GitHub-Delivery' => '72d3162e-cc78-11e3-81ab-4c9367dc0958',
          'X-GitHub-Event' => 'push'
        },
        'body' => payload
      }
    }

    let(:response) { subject.handler(event: event, context: context) }

    it 'responds successfully' do
      allow_any_instance_of(Aws::DynamoDB::Client).to receive(:put_item).and_return(true)

      expect(response).to include(statusCode: 200)
    end

    it 'responds with error when an error is raised' do
      allow_any_instance_of(Aws::DynamoDB::Client).to receive(:put_item).and_raise(Aws::DynamoDB::Errors::ServiceError)

      expect(response).to include(statusCode: 500)
    end
  end
end
