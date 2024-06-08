# frozen_string_literal: true
require 'mkmf'

extension_name = 'libip2region'
dir_config(extension_name)

create_makefile(extension_name)
