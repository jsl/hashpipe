require 'right_aws'

module HashPipe
  module Backends

    class S3

      def initialize(archived_attribute)
        @archived_attribute = archived_attribute
        @config = HashPipe::GlobalConfiguration.instance[:s3]
      end

      def save(content)
        bucket.put( key_name, StringIO.new( content ) ) unless content.nil?
      end

      def destroy
        bucket.key(key_name).delete
      end

      def load
        bucket.get(key_name)
      end

      private

      def bucket
        @bucket ||= right_aws_s3.bucket(bucket_name)
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
        @config[:bucket]
      end

      def key_name
        [ @archived_attribute.instance.class.table_name,
          @archived_attribute.name,
          @archived_attribute.instance.uuid ].join('/')
      end

      # Returns a string representing whether we use http or https for this
      # connection.
      def protocol
        @config[:protocol] || 'https'
      end
    end

  end
end