module Griddler
  module Sendgrid
    class Adapter
      def initialize(params)
        @params = params
      end

      def self.normalize_params(params)
        adapter = new(params)
        adapter.normalize_params
      end

      def normalize_params
        params.merge(
          to: recipients(:to),
          cc: recipients(:cc),
          attachments: attachment_files,
        )
      end

      private

      attr_reader :params

      def recipients(key)
        ( params[key] || '' ).split(',')
      end

      def attachment_files
        info = JSON.parse(params.delete('attachment-info')) rescue {}
        attachment_count = params[:attachments].to_i
        attachment_count.times.map do |index|
          params.delete("attachment#{index + 1}".to_sym).tap{|file|
            # fix filename
            file.original_filename = info["attachment#{index + 1 }"]['filename']
          }
        end
      end
    end
  end
end
