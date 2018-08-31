class EventsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json do
        start_date  = Date.parse(params[:start_date]) rescue nil
        end_date    = Date.parse(params[:end_date]) rescue nil
        if start_date && end_date
          events  = Event
                      .between(start_date, end_date)
                      .ordered
                      .map do |event|
                        image = event.image.variant.resize('100x100')

                        event.attributes.merge(
                          "attending" => Rsvp.where(event: event, user: current_user).exists?,
                          "image" => {
                            "name" => image.send(:filename),
                            "url" => url_for(image)
                          }
                        )
                      end
                      .group_by do |event|
                        event["start_at"].to_date
                      end
          render json: events
        else
          head :bad_request
        end
      end
    end
  end

  def create
    event = current_user.events.new(event_params)
    if event.save
      render json: event
    else
      render json: event.error.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    event = current_user.events.find(params[:id])
    event.destroy
    render json: event
  end

  def show
    event = Event.find(params[:id])
    image = event.image.variant(resize: '100x100')
    
    @event = event.attributes.merge(
              "attending" => Rsvp.where(event: event, user: current_user).exists?,
              "image" => {
                "name" => image.send(:filename),
                "url" => url_for(image)
              }      
            )
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :start_at, :end_at, :location, :street_address, :city, :state, :zip, :image)
  end

end
