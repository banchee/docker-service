# frozen_string_literal: false

require 'resque_task'
require 'pdg_data_events'
require 'pdg_data_receiver'
require 'pubbit'

namespace :publish do
  desc 'Publish a Test Event to resque'
  task test: :environment do
    publisher = Pubbit::Publisher.new(
      amqp: {
        url: 'http://rabbitmq:15672',
        username: 'guest',
        password: 'guest',
        vhost: '/',
        exchange: 'school-api',
        routing_key: 'school-api.updates'
      }
    )

    begin
      publisher.declare_exchange
    rescue => e
      puts e.message
    end

    factory = ProdigyDataEvents::EventFactory.new(
      supported_models: ['my_model_a', 'my_model_b'],
      application_version: '1.0.1'
    )

    # Build a data event
    event = factory.data_event(
      model: 'my_model_a',
      id: '1',
      url: "https://your.app.domain/api/my_model_a/1/",
      operation: ProdigyDataEvents::UPDATE,
      updated_fields: ['field_1', 'field_2'],
      updated_at: Time.now
    )
    puts event.serialize_to_string

    begin
      publisher.publish(event.serialize_to_string)
    rescue => e
      puts e
      raise e.backtrace
    end
  end
end
