class GraphqlChannel < ApplicationCable::Channel
  def subscribed
    @subscription_ids = []
    puts "subscribed:", params.inspect
    # stream_from "#{params[]}"
  end

  def yo(*args)
    puts 'yo', params.inspect, args.inspect
  end

  # def send(first, second, third)
  #   puts 'byaaah', params.inspect, first, second.class, third.class, "\n\n"
  #   # puts 'send', data.inspect
  #   # puts 'send', params.inspect
  #   execute(
  #     'query' => params['query'],
  #     # 'variables' => {},
  #     # 'operationName' => 'test'
  #   )
  # end

  def execute(data)
    puts 'execute', data.inspect
    query = data["query"]
    variables = ensure_hash(data["variables"])
    operation_name = data["operationName"]
    context = {
      # Re-implement whatever context methods you need
      # in this channel or ApplicationCable::Channel
      # current_user: current_user,
      # Make sure the channel is in the context
      channel: self,
    }

    result = SekaiSchema.execute(
      "{hex {title}}"
      # query: query,
      # context: context,
      # variables: variables,
      # operation_name: operation_name
    )

    payload = {
      result: result.to_h,
      more: result.subscription?,
    }

    # Track the subscription here so we can remove it
    # on unsubscribe.
    if result.context[:subscription_id]
      @subscription_ids << result.context[:subscription_id]
    end

    transmit(payload)
  end

  def unsubscribed
    @subscription_ids.each { |sid|
      SekaiSchema.subscriptions.delete_subscription(sid)
    }
  end

  private

  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end
end
