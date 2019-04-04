####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Models

    # A model to repesent an Ouput in the Wowza Streaming Cloud API.
    #
    class Output < WscSdk::Model

      model_name_singular :output
      model_name_plural   :outputs


      #---------------------------------------------------------------------------
      #  ___     _
      # / __| __| |_  ___ _ __  __ _
      # \__ \/ _| ' \/ -_) '  \/ _` |
      # |___/\__|_||_\___|_|_|_\__,_|
      #
      #---------------------------------------------------------------------------

      attribute :id,                  :string,    access: :read
      attribute :name,                :string,    access: :read
      attribute :transcoder_id,       :string,    access: :read
      attribute :stream_format,       :string
      attribute :passthrough_video,   :boolean
      attribute :passthrough_audio,   :boolean
      attribute :aspect_ratio_height, :integer
      attribute :aspect_ratio_width,  :integer
      attribute :bitrate_audio,       :integer
      attribute :bitrate_video,       :integer
      attribute :h264_profile,        :string
      attribute :framerate_reduction, :string
      attribute :keyframes,           :string
      attribute :created_at,          :datetime,  access: :read
      attribute :updated_at,          :datetime,  access: :read

      #---------------------------------------------------------------------------
      #    _                   _      _   _
      #   /_\   ______ ___  __(_)__ _| |_(_)___ _ _  ___
      #  / _ \ (_-<_-</ _ \/ _| / _` |  _| / _ \ ' \(_-<
      # /_/ \_\/__/__/\___/\__|_\__,_|\__|_\___/_||_/__/
      #
      #---------------------------------------------------------------------------


      # Output Stream Targets endpoint for stream targets associated with the
      # output.
      #
      # @return [WscSdk::Endpoints::OutputStreamTargets]
      #   An instance of the OutputStreamTargets endpoint, with the results
      #   limited to the outputs stream targets associted with this output.
      #
      def output_stream_targets
        @output_stream_targets ||= WscSdk::Endpoints::OutputStreamTargets.new(endpoint.client, parent_path: endpoint.find_path(self.primary_key))
      end

    end
  end
end
