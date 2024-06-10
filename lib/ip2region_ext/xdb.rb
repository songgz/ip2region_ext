# frozen_string_literal: true
require 'singleton'
module Ip2regionExt
  class Xdb
    include Singleton

    def connect(opt = {})
      @option = {db_path: nil, db_type: :file}.merge(opt)
      @searcher =  XdbSearcherT.new()
      #@vector_index = XdbVectorIndexT.new()
      #@content = XdbContentT.new()

      case @option[:db_type]
      when :file
        load_by_file
      when :index
        load_by_index
      when :cache
        load_by_cache
      else
        load_by_file
      end
    end

    def load_by_file
      err = Ip2regionExt.xdb_new_with_file_only(@searcher, @option[:db_path])
      raise Error.new("failed to create xdb searcher from `#{@option[:db_path]}` with errno=#{err}\n") if err != 0
    end

    def load_by_index
      @vector_index = Ip2regionExt.xdb_load_vector_index_from_file(@option[:db_path])
      raise Error.new("failed to load vector index from `#{@option[:db_path]}`\n") unless @vector_index

      err = Ip2regionExt.xdb_new_with_vector_index(@searcher.pointer, @option[:db_path], @vector_index)
      raise Error.new("failed to create vector index cached searcher with errno=#{err}\n") if err != 0
    end

    def load_by_cache
      @content = Ip2regionExt.xdb_load_content_from_file(@option[:db_path])
      raise Error.new("failed to load xdb content from `#{}`\n") unless @content

      err = Ip2regionExt.xdb_new_with_buffer(@searcher, @content)
      raise Error.new("failed to create content cached searcher with errno=#{err}\n") if err != 0
    end

    def query(ip_address)
      region_buffer = FFI::MemoryPointer.new(:char, 256)
      err = Ip2regionExt.xdb_search_by_string(@searcher, ip_address, region_buffer, region_buffer.size)
      raise Error.new("failed search(#{ip_address}) with errno=#{err}\n") if err != 0
      region_buffer.read_string.force_encoding('UTF-8')
    end

    def close
      Ip2regionExt.xdb_close(@searcher)
      Ip2regionExt.xdb_close_vector_index(@vector_index) if @option[:db_type] == :index
      Ip2regionExt.xdb_close_content(@content) if @option[:db_type] == :cache
    end

    def check_ip(ip_address)
      result = FFI::MemoryPointer.new(:int)
      err = Ip2regionExt.xdb_check_ip(ip_address, result)
      raise Error.new("failed check ip(#{ip_address}) with errno=#{err}\n") if err != 0
      result.get_int(0)
    end


  end

end

