class EtagCaching
  CACHE_PERIOD = 10.minutes

  def initialize(app)
    @app = app
  end

  def call(env)
    if self.class.fresh?(env['HTTP_IF_NONE_MATCH'])
      return [304, {}, ['Not Modified']]
    end
    @app.call(env)
  end

  def self.fresh?(etag_header)
    return unless data = Rails.cache.read(digest)
    site_id, timestamp = Offer.where(id: data[:offer_id]).pluck(:site_id, :updated_at)
    SettingsChange.where(site_id: site_id, created_at: lookup_period).empty? &&
      !((data[:cached_at]..Time.zone.now).include?(timestamp))
  end
end

class OffersController < ApplicationController
  def show
    @offer = Offer.find(params[:id])
    digest = SecureRandom.uuid
    data = { offer_id: offer.id, cached_at: Time.zone.now, }
    Rails.cache.write(digest, data, expires_in: CACHE_PERIOD.from_now)
    response.headers['Cache-Control'] = 'max-age=0, private, must-revalidate'
    response.headers['ETag'] = %(W/"#{digest}")
  end
end
