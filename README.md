
# Ip2regionExt

## 介绍

这是一个ip2region库c客户端的ruby ffi扩展,  基于 [lionsoul2014/ip2region](https://github.com/lionsoul2014/ip2region) 最新版本开发

直接调用c原生api,充分发挥IO操作的性能优势

## 安装
`gem install ip2region_ext`
## 使用

```ruby
require 'ip2region_ext'

# 查询
#db_type = :file|:index|:cache
#Ip2regionExt.connect({db_type: :index, db_path: "/var/ip2region.xdb"})
Ip2regionExt.connect({db_type: :index})
p Ip2regionExt.search('114.114.114.114')
Ip2regionExt.close
# => "中国|0|辽宁省|丹东市|联通"

```

## 如何下载外挂 xdb 文件

下载这个文件 [https://github.com/lionsoul2014/ip2region/blob/master/data/ip2region.xdb](https://github.com/lionsoul2014/ip2region/blob/master/data/ip2region.xdb)


## 协议

MIT 协议
