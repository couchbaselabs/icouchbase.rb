# coding: utf-8
#
# Author:: Couchbase <info@couchbase.com>
# Copyright:: 2013 Couchbase, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'icouchbase/version'

Gem::Specification.new do |spec|
  spec.name          = "icouchbase"
  spec.version       = ICouchbase::VERSION
  spec.authors       = ["Sergey Avseyev"]
  spec.email         = ["sergey.avseyev@gmail.com"]
  spec.description   = %q{Command line tool to work with Couchbase cluster}
  spec.summary       = %q{Interactive Couchbase}
  spec.homepage      = "http://labs.couchbase.com/icouchbase.rb"
  spec.license       = "ASL-2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "couchbase", "~> 1.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
