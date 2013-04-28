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

  class DSL
    attr_reader :db

    def initialize(db)
      @db = db
    end

    def self.commands
      @commands ||= {}
    end

    def self.command(name, defaults, &block)
      commands[name.to_s] = {
        :defaults => defaults,
        :block => block
      }
    end

    def normalize!(str)
      map = {
        '\n' => "\n",
        '\r' => "\r",
        '\t' => "\t",
        '\b' => "\b",
        '\a' => "\a"
      }
      str.gsub!(/\\[nrtba]/, map)
    end

    def parse(input)
      tokens = []

      # split input
      input.scan(/([^\s"']+)|"(([^"]|(?<=\\)")+)"/) do |m|
        tokens << (m[0] || m[1])
      end

      tok = tokens.shift
      cmd = self.class.commands[tok]
      raise ParseError, "unknown command \"#{tok}\"" unless cmd

      options = cmd[:defaults].dup
      # parse options
      while tok = tokens.shift
        # handle options terminator
        break if tok == "--"
        # is it first argument?
        if tok[0] != "-"
          tokens.unshift(tok)
          break
        end
        name = tok[1..-1]
        if name.nil? || name.empty?
          raise ParseError, "invalid option \"#{tok}\""
        end
        name = name.to_sym
        unless options.keys.include?(name)
          raise ParseError, "unknown option \"#{name}\""
        end
        tok = tokens.shift
        unless tok
          raise ParseError, "option \"#{name}\" requires argument"
        end
        # guess type using default value
        options[name] = case options[name]
                        when Fixnum, Bignum
                          Integer(tok)
                        when Float
                          Float(tok)
                        else
                          tok
                        end
      end

      # check arguments number
      num = cmd[:block].arity - 1
      if tokens.size != num
        raise ParseError, "wrong number of arguments (#{tokens.size} for #{num})"
      end
      tokens.each{|t| normalize!(t)}
      [cmd[:block], options, *tokens]
    end

  end
end
