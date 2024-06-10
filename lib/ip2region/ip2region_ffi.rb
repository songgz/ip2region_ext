require 'ffi'

module Ip2region
  extend FFI::Library
  ffi_lib File.join(__dir__, '../','libip2region.so')

  XDB_HEADER_INFO_LENGTH = 256
  XDB_VECTOR_INDEX_LENGTH = 524288

  class FILE < FFI::Struct
    layout :_ptr, :pointer,  # 文件指针
           :_cnt, :int,      # 缓冲区剩余字节数
           :_base, :pointer,  # 缓冲区基地址
           :_flag, :int,     # 文件状态标志
           :_file, :int,     # 文件描述符
           :_charbuf, :int,  # 是否为字符缓冲区
           :_bufsiz, :int,   # 缓冲区大小
           :_tmpfname, :string  # 临时文件名
  end

  class XdbHeaderT < FFI::Struct
    layout :version, :ushort,
           :index_policy, :ushort,
           :created_at, :uint,
           :start_index_ptr, :uint,
           :end_index_ptr, :uint,
           :length, :uint,
           :buffer, [:char, XDB_HEADER_INFO_LENGTH] # xdb_header_info_length 需要替换为实际的值
  end

  class XdbVectorIndexT < FFI::Struct
    layout :length, :uint,
           :buffer, [:char, XDB_VECTOR_INDEX_LENGTH]
  end

  class XdbContentT < FFI::Struct
    layout :length, :uint,
           :buffer, :pointer
  end

  class XdbSearcherT < FFI::Struct
    layout :handle, :pointer,
           :header, :string,
           :io_count, :int,
           :v_index, :pointer, # 指向 xdb_vector_index_t 结构体的指针
           :content, :pointer   # 指向 xdb_content_t 结构体的指针
  end

  #attach_function :xdb_load_content_from_file, [:string], XdbContentT.ptr
  attach_function :xdb_new_with_file_only, [:pointer, :string], :int
  attach_function :xdb_check_ip, [:string, :pointer], :int
  attach_function :xdb_search_by_string, [ :pointer, :string, :pointer, :size_t ], :int
  #attach_function :xdb_search, [:pointer, :uint, :string, :size_t], :int
  attach_function :xdb_close, [:pointer], :void
  attach_function :xdb_load_vector_index_from_file, [:string], XdbVectorIndexT.ptr
  attach_function :xdb_new_with_vector_index, [:pointer, :string, :pointer], :int
  attach_function :xdb_close_vector_index, [:pointer], :void
  attach_function :xdb_load_content_from_file, [:string], :pointer
  attach_function :xdb_new_with_buffer, [:pointer, :pointer], :int
  attach_function :xdb_close_content, [:pointer], :void


end

