require 'aws-sdk-dynamodb'
require 'json'

class GithubEvent
  attr_accessor :id, :event, :payload, :processed, :created_at, :updated_at

  def self.build(event)
    github_event = GithubEvent.new
    now = Time.now.to_s

    github_event.id = event['headers']['X-GitHub-Delivery']
    github_event.event = event['headers']['X-GitHub-Event']
    github_event.payload = JSON.parse(event['body'])
    github_event.processed = false
    github_event.created_at = now
    github_event.updated_at = now

    github_event
  end

  def compact_recursively(hash)
    p = proc do |*args|
      v = args.last
      v.delete_if(&p) if v.respond_to? :delete_if
      v.nil? || v.respond_to?(:"empty?") && v.empty?
    end

    hash.delete_if(&p)
  end

  def to_h
    {
      table_name: 'github_events',
      item: {
        id: id,
        event: event,
        payload: compact_recursively(payload),
        processed: processed,
        created_at: created_at,
        updated_at: updated_at
      }
    }
  end

  def save!
    puts "Saving Github Event: #{to_h}"
    dynamo = Aws::DynamoDB::Client.new(region: 'eu-central-1')
    dynamo.put_item(to_h)
    puts 'Github Event successfuly saved'
    true
  rescue => error
    puts "Unable to save GithubEvent: #{error.message}"
    false
  end
end

def handler(event:, context:)
  puts "Webhook triggered: #{event}"

  if GithubEvent.build(event).save!
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
