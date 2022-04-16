# encoding: utf-8
require 'qcloud_cos/utils'
require 'qcloud_cos/multipart'
require 'qcloud_cos/model/list'

module QcloudCos
  module Api
    module Object
      def put(object_key, file)
        base_request('put', object_key, { body: file })
      end

      # 检查文件是否存在
      #
      # @param object_key [String] 指定文件key
      #
      # @return True or False
      def head(object_key)
        bucket = config.bucket
        sign = authorization.sign(bucket)
        url = generate_rest_url(bucket, object_key)
        response = http.head(url, headers: { 'Authorization' => sign })
        return response.code == 200
      end

      def get(object_key)
        bucket = config.bucket
        sign = authorization.sign(bucket)
        url = generate_rest_url(bucket, object_key)
        http.get(url, headers: { 'Authorization' => sign })
      end

      private

      def base_request(http_verb, object_key, options)
        bucket = config.bucket
        sign = authorization.sign(bucket)
        url = generate_rest_url(bucket, object_key)
        body = options.delete(:body)
        options = { headers: { 'Authorization' => sign }, body: body }
        http.send(http_verb.downcase.to_sym, url, options)
      end
    end
  end
end