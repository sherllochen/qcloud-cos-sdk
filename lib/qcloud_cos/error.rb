# encoding: utf-8
module QcloudCos
  class Error < StandardError; end

  class RequestError < Error
    attr_reader :code
    attr_reader :message
    attr_reader :origin_response

    # Error example:
    # {"Error"=>
    #   {"Code"=>"SignatureDoesNotMatch",
    #    "Message"=>"The Signature you specified is invalid.",
    #    "Resource"=>"99yee-test-1253434451.cos.ap-chengdu.myqcloud.com",
    #    "RequestId"=>"NjI1ODE4OGZfNzc5ZTU4NjRfOTA3MF80MmE1NzAw",
    #    "TraceId"=>"OGVmYzZiMmQzYjA2OWNhODk0NTRkMTBiOWVmMDAxODc0OWRkZjk0ZDM1NmI1M2E2MTRlY2MzZDhmNmI5MWI1OTBjYzE2MjAxN2M1MzJiOTdkZjMxMDVlYTZjN2FiMmI0ZDJlNTdmMDFmMGJhYzkxMzI2NjU4ZjM3NGRhYTNkNDQ="}}
    def initialize(response)
      if response.parsed_response.key?('Error')
        @code = response.parsed_response['Error']['Code']
        @message = response.parsed_response['Error']['Message']
      end
      @origin_response = response
      super("API ERROR Code=#{@code}, Message=#{@message}")
    end
  end

  class InvalidFolderPathError < Error
    def initialize(msg)
      super(msg)
    end
  end

  class InvalidFilePathError < Error
    def initialize
      super('文件名不能以 / 结尾')
    end
  end

  class FileNotExistError < Error
    def initialize
      super('文件不存在')
    end
  end

  class MissingBucketError < Error
    def initialize
      super('缺少 Bucket 参数或者 Bucket 不存在')
    end
  end

  class MissingSessionIdError < Error
    def initialize
      super('分片上传不能缺少 Session ID')
    end
  end

  class InvalidNumError < Error
    def initialize
      super('单次列取目录数量必须在1~199')
    end
  end
end
