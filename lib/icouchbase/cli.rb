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

require 'readline'
require 'optparse'

module ICouchbase

  module CLI
    class << self
      def start
        # parse ARGV
        options = {
          :hostname => 'localhost',
          :port => 8091,
          :password => nil,
          :bucket => 'default'
        }
        OptionParser.new do |opts|
          opts.banner = "Usage: icouchbase [options]"
          opts.on("-a", "--address ADDRESS", "Address to connect to (default: #{options[:hostname]}:#{options[:port]})") do |v|
            host, port = v.split(':')
            options[:hostname] = host.empty? ? 'localhost' : host
            options[:port] = port.to_i > 0 ? port.to_i : 8091
          end
          opts.on("-p", "--password PASSWORD", "Password to log with (default: none)") do |v|
            options[:password] = v
          end
          opts.on("-b", "--bucket NAME", "Name of the bucket to connect to (default: #{options[:bucket]})") do |v|
            options[:bucket] = v.empty? ? "default" : v
          end
          opts.on_tail("-?", "--help", "Show this message") do
            puts opts
            exit(0)
          end
        end.parse!

        # establish connection
        begin
          print "Connecting to #{options[:bucket]}@#{options[:hostname]}:#{options[:port]} ... "
          STDOUT.flush
          conn = Couchbase.connect(options)
          puts "DONE"
        rescue Couchbase::Error::Base => ex
          "ERROR: #{ex.message}"
          exit(1)
        end

        history = File.join(ENV['HOME'], ".icouchbase_history")
        at_exit do
          begin
            File.open(history, "w+") do |f|
              f.puts(Readline::HISTORY.to_a)
            end
          rescue StandardError
          end
        end
        begin
          File.readlines(history, "r").each do |line|
            line.strip!
            Readline::HISTORY.push(line) unless line.empty?
          end
        rescue StandardError
        end

        # handle user commands
        puts "Welcome to Interactive Couchbase"
        cmd = Handler.new(conn)
        while true
          input = Readline.readline("couchbase> ", false)
          exit(0) if input.nil?
          input.strip!
          next if input.empty?
          # remove sequential duplicates
          if input != Readline::HISTORY.to_a[-1]
            Readline::HISTORY.push(input)
          end
          puts cmd.exec(input.chomp)
        end
      end

    end
  end

end
