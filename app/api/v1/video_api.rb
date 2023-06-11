module V1
  class VideoApi < Grape::API
    before { authenticate! unless route.settings[:auth] && route.settings[:auth][:disabled] }

    resources :videos do
      desc 'Get api/v1/videos/'
      params do
        optional :page, type: Integer
        optional :per, type: Integer
      end
      get '/' do
        videos = current_user.videos.order(status: :desc, created_at: :desc)
        videos = videos.page(params[:page]).per(params[:per])
        render videos, meta: pagination_dict(videos)
      end

      desc 'post api/v1/videos/'
      params do
        requires :url, type: String
      end
      post '/' do
        begin
          is_video_existed = current_user.videos.find_by(url: params[:url])
          error!('url video is existed!', 422) if is_video_existed
          VideoInfo.provider_api_keys = { youtube: 'AIzaSyDzstjY08e5enI7MgKaOHy4Ps-WwPCfJso'}
          video_info = VideoInfo.new params[:url]
          title = video_info.title || "default_title"
          description = video_info.description || "default_description"
          thumbnail_url = video_info.thumbnail_medium
          video = current_user.videos.new(url: params[:url], title: title,
                                          description: description, thumbnail_url: thumbnail_url)
          if video.save
            render video
          else
            error!(video.errors.full_messages.first, 422)
          end
        rescue
          error!('cannot save videos', 422)
        end
      end
    end
  end
end
