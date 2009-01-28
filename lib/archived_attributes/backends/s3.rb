require 'right_aws'

module ArchivedAttributes
  module Backends

    class S3

      def initialize(archived_attribute)
        @archived_attribute = archived_attribute
        @config = ArchivedAttributes::GlobalConfiguration.instance['s3']
      end

      def save(content)
        bucket.put(content)
      end

      def load
        bucket.get(key_name)
      end

      private

      def bucket
        @bucket ||= right_aws_s3.bucket(bucket_name, true)
      end

      def right_aws_s3        
        @s3 ||= RightAws::S3.new(
          @config[:access_key],
          @config[:secret_key]
        )
      end

      # Returns the bucket name to be used based on attributes of the archived
      # attribute.
      def bucket_name
        @config['bucket']
      end

      def key_name
        [ @archived_attribute.instance.class.to_s.downcase,
          @archived_attribute.name,
          @archived_attribute.instance.uuid ].join('/')
      end

      # Returns a string representing whether we use http or https for this
      # connection.
      def protocol
        @config['protocol'] || 'https'
      end
    end

  end
end