# frozen_string_literal: true

require_relative "ip2region_ext/version"
require_relative 'ip2region_ext/ip2region_ffi'
require_relative 'ip2region_ext/xdb'

module Ip2regionExt
  class Error < StandardError; end

  @@xdb_path = File.join(__dir__, '../db','ip2region.xdb')

  def self.connect(option = {})
    option[:db_path] ||= @@xdb_path
    Xdb.instance.connect(option)
  end

  def self.search(ip_address)
    Xdb.instance.query(ip_address)
  end

  def self.close
    Xdb.instance.close
  end


end
