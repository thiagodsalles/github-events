class EventsController < ApplicationController
  before_action :set_event, only: [:show]
  skip_before_action :verify_authenticity_token 

  http_basic_authenticate_with name: Rails.application.credentials.get_token[:username].to_s,
                               password: Rails.application.credentials.get_token[:password].to_s,
                               except: :create
  
  def show
    render json: @event.map { |event| {id: event.id, number: event.number, state: event.state, created_at: I18n.l(event.created_at), updated_at: I18n.l(event.updated_at) }}, status: :ok
  end
  
  def create
    if verify_signature(request.body.read)
      @event = Event.new(event_params)
      respond_to do |format|
        if @event.save
          format.json { render json: @event, status: :created }
        else
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  def verify_signature(payload_body)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), Rails.application.credentials.github_secret[:sercret].to_s, payload_body)
    Rack::Utils.secure_compare(signature, request.headers['X-Hub-Signature'])
  end

  def set_event
    @event = Event.where(number: params[:number])
  end

  def event_params
    params.require(:issue).permit(:number, :state)
  end
end