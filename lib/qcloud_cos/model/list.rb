require 'qcloud_cos/model/file_object'
require 'qcloud_cos/model/folder_object'
require 'forwardable'

module QcloudCos
  class List
    include Enumerable
    extend Forwardable

    attr_reader :context, :dircount, :filecount, :has_more
    def_delegators :@objects, :[], :each, :size, :inspect

    # 自动将 Hash 构建成对象
    # result example:
    # {"ListBucketResult"=>
    #   {"Name"=>"99yee-test-1253434451",
    #    "Prefix"=>nil,
    #    "Marker"=>nil,
    #    "MaxKeys"=>"1000",
    #    "IsTruncated"=>"false",
    #    "Contents"=>
    #     [{"Key"=>"test.txt",
    #       "LastModified"=>"2022-04-14T12:22:58.000Z",
    #       "ETag"=>"\"d41d8cd98f00b204e9800998ecf8427e\"",
    #       "Size"=>"0",
    #       "Owner"=>{"ID"=>"1253434451", "DisplayName"=>"1253434451"},
    #       "StorageClass"=>"STANDARD"},
    #      {"Key"=>"test/",
    #       "LastModified"=>"2022-03-23T09:29:43.000Z",
    #       "ETag"=>"\"d41d8cd98f00b204e9800998ecf8427e\"",
    #       "Size"=>"0",
    #       "Owner"=>{"ID"=>"1253434451", "DisplayName"=>"1253434451"},
    #       "StorageClass"=>"STANDARD"},
    #      {"Key"=>"test/gongan_beian.png",
    #       "LastModified"=>"2022-03-23T09:30:13.000Z",
    #       "ETag"=>"\"d0289dc0a46fc5b15b3363ffa78cf6c7\"",
    #       "Size"=>"19256",
    #       "Owner"=>{"ID"=>"1253434451", "DisplayName"=>"1253434451"},
    #       "StorageClass"=>"STANDARD"}]}}
    def initialize(result)
      #todo adpat new result data structure
      @context = result['context']
      @dircount = result['dircount']
      @filecount = result['filecount']
      @has_more = result['has_more']
      @objects = build_objects(result['infos'])
    end

    private

    def build_objects(objects)
      objects.map do |obj|
        if obj.key?('access_url')
          QcloudCos::FileObject.new(obj)
        else
          QcloudCos::FolderObject.new(obj)
        end
      end
    end
  end
end
