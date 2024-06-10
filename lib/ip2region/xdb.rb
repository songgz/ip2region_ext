# frozen_string_literal: true
module Ip2region
  class Xdb
    include ::Singleton

    def connect(db_path, db_type = :file)
      @db_path = db_path
      @searcher =  XdbSearcherT.new()
      #@vector_index = XdbVectorIndexT.new()
      #@content = XdbContentT.new()
      @db_type = db_type

      case @db_type
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
      err = Ip2region.xdb_new_with_file_only(@searcher, @db_path)
      raise Error.new("failed to create xdb searcher from `#{@db_path}` with errno=#{err}\n") if err != 0
    end

    def load_by_index
      @vector_index = Ip2region.xdb_load_vector_index_from_file(@db_path)
      raise Error.new("failed to load vector index from `#{@db_path}`\n") unless @vector_index

      err = Ip2region.xdb_new_with_vector_index(@searcher.pointer, path, @vector_index)
      raise Error.new("failed to create vector index cached searcher with errno=#{err}\n") if err != 0
    end

    def load_by_cache
      @content = Ip2region.xdb_load_content_from_file(@db_path)
      raise Error.new("failed to load xdb content from `#{}`\n") unless @content

      err = Ip2region.xdb_new_with_buffer(@searcher, @content)
      raise Error.new("failed to create content cached searcher with errno=#{err}\n") if err != 0
    end

    def query(ip_address)
      region_buffer = FFI::MemoryPointer.new(:char, 256)
      err = Ip2region.xdb_search_by_string(@searcher, ip_address, region_buffer, region_buffer.size)
      raise Error.new("failed search(#{ip_address}) with errno=#{err}\n") if err != 0
      region_buffer.read_string.force_encoding('UTF-8')
    end

    def close
      Ip2region.xdb_close(@searcher)
      Ip2region.xdb_close_vector_index(@vector_index) if @db_type == :index
      Ip2region.xdb_close_content(@content) if @db_type == :cache
    end

    def check_ip(ip_address)
      result = FFI::MemoryPointer.new(:int)
      err = Ip2region.xdb_check_ip(ip_address, result)
      raise Error.new("failed check ip(#{ip_address}) with errno=#{err}\n") if err != 0
      result.get_int(0)
    end


  end

end

