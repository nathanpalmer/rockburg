class ActivitiesController < ApplicationController
  def new
    band = Band.ensure!(params[:band_id])
    context = nil

    case params[:type]
    when 'practice'
      context = Activity::Practice.call(
        band: params[:band_id],
        hours: params[:hours]
      )

    when 'write_song'
      context = Activity::WriteSong.call(
        band: params[:band_id],
        hours: params[:hours]
      )

    when 'gig'
      context = Activity::PlayGig.call(
        band: params[:band_id],
        venue: params[:venue],
        hours: params[:hours] || 2
      )

    when 'record_single'
      context = Activity::RecordSingle.call(
        band: params[:band_id],
        studio: params[:studio][:studio_id],
        song: params[:song_id],
        song_name: params[:studio][:song_name]
      )

    when 'record_album'
      context = Activity::RecordAlbum.call(
        band: params[:band_id],
        studio: params[:studio][:studio_id],
        recording_ids: params[:recording_ids]
      )

    when 'release'
      context = Activity::ReleaseRecording.call(
        band: params[:band_id],
        recording: params[:recording][:id],
        hours: 1
      )

    when 'rest'
      context = Activity::Rest.call(
        band: params[:band_id],
        hours: params[:hours]
      )
    else
      raise ArgumentError.new("Unknown Type[#{params[:type]}]")
    end

    if context && context.activity.save
      redirect_to band_path(band)
    end
  end
end
