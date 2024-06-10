# frozen_string_literal: true

require_relative "ip2region/version"
require_relative 'ip2region/ip2region_ffi'

module Ip2region
  class Error < StandardError; end

  @@xdb_path = File.join(__dir__, '../db','ip2region.xdb')

  def self.connect(db_path = nil, db_type = :file)
    Xdb.instance.connect(db_path || @@xdb_path , db_type)
  end

  def self.search(ip_address)
    Xdb.instance.query(ip_address)
  end

  def self.close
    Xdb.instance.close
  end


end
