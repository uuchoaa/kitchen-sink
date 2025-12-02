# frozen_string_literal: true

class ScrapesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "scrapes"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

