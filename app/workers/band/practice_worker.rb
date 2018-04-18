class Band::PracticeWorker < ApplicationWorker
  def perform(band, hours)
    Band::Practice.(band: band, hours: hours)
    band = Band.ensure(band)

    ActionCable.server.broadcast "activity_notifications:#{band.manager_id}",
      band: band.id,
      message: "<i class='fa fa-check-circle'></i> Activity done!</div>"
  end
end
