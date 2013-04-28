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

module ICouchbase

  class Handler < DSL

    command :set, {:ttl => 0, :flags => 0, :cas => 0} do |opts, key, value|
      r = db.set(key, value, opts)
      {:cas => r, :flags => opts[:flags]}
    end

    command :get, {:ttl => 0} do |opts, key|
      opts.update(:extended => true)
      r = db.get(key, opts)
      {:value => r[0], :flags => r[1], :cas => r[2]}
    end

    def exec(input)
      block, *args = parse(input)
      r = instance_exec(*args, &block)
      ret = []
      ret << "CAS:   #{r[:cas]}" if r[:cas]
      ret << "FLAGS: #{r[:flags]}" if r[:flags]
      ret << r[:value] if r[:value]
      ret.join("\n")
    rescue ParseError => e
      "ERROR: #{e.message}"
    rescue Couchbase::Error::Base => e
      "ERROR: #{e.message}"
    end

  end
end
