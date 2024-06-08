# frozen_string_literal: true

require_relative "ip2region/version"
require_relative 'ip2region/ip2region_ffi'

module Ip2region
  class Error < StandardError; end

  @@xdb_path = File.join(__dir__, '../ip2region','ip2region.xdb')
  def self.search(ip_address)
    xdb_searcher_t_ptr = IP2Region::XdbSearcherT.new()

    err = IP2Region.xdb_new_with_file_only(xdb_searcher_t_ptr, @@xdb_path)
    raise("failed to create xdb searcher from `#{@@xdb_path}` with errno=#{err}\n") if err != 0

    region_buffer = FFI::MemoryPointer.new(:char, 256)
    err = IP2Region.xdb_search_by_string(xdb_searcher_t_ptr, ip_address, region_buffer, region_buffer.size)
    raise("failed search(#{ip_address}) with errno=#{err}\n") if err != 0

    IP2Region::xdb_close(xdb_searcher_t_ptr)
    region_buffer.read_string.force_encoding('UTF-8')
  end

  def self.search_by_index(ip_address)
    xdb_searcher_t_ptr = IP2Region::XdbSearcherT.new()

    xdb_vector_index_t = IP2Region.xdb_load_vector_index_from_file(@@xdb_path)
    raise("failed to load vector index from `#{@@xdb_path}`\n") unless xdb_vector_index_t

    err = IP2Region.xdb_new_with_vector_index(xdb_searcher_t_ptr.pointer, path, xdb_vector_index_t)
    raise("failed to create vector index cached searcher with errno=#{err}\n") if err != 0

    region_buffer = FFI::MemoryPointer.new(:char, 256)
    err = IP2Region.xdb_search_by_string(xdb_searcher_t_ptr, ip_address, region_buffer, region_buffer.size)
    raise("failed search(#{ip_address}) with errno=#{err}\n") if err != 0

    IP2Region.xdb_close(xdb_searcher_t_ptr)
    IP2Region.xdb_close_vector_index(xdb_vector_index_t)

    region_buffer.read_string.force_encoding('UTF-8')
  end

  def self.search_by_cache(ip_address)
    xdb_searcher_t_ptr = IP2Region::XdbSearcherT.new()

    xdb_content_t = IP2Region.xdb_load_content_from_file(@@xdb_path)
    raise("failed to load xdb content from `#{}`\n") unless xdb_content_t

    err = IP2Region.xdb_new_with_buffer(xdb_searcher_t_ptr, xdb_content_t)
    raise("failed to create content cached searcher with errno=#{err}\n") if err != 0

    region_buffer = FFI::MemoryPointer.new(:char, 256)
    err = IP2Region.xdb_search_by_string(xdb_searcher_t_ptr, ip_address, region_buffer, region_buffer.size)
    raise("failed search(#{ip_address}) with errno=#{err}\n") if err != 0

    IP2Region.xdb_close(xdb_searcher_t_ptr)
    IP2Region.xdb_close_content(xdb_content_t)

    region_buffer.read_string.force_encoding('UTF-8')
  end



  def self.check_ip
    ip_address = "113.237.123.72"
    result = FFI::MemoryPointer.new(:int)
    p err = IP2Region.xdb_check_ip(ip_address, result)
    p result.get_int(0)
  end
end
