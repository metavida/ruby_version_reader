require 'date'
require 'time'

class RubyVersionReader
  VERSION = '0.1.0'

  attr_accessor :path, :environment_manager

  def initialize(given_path, given_environment_manager = 'rvm')
    given_path = './' if given_path.empty?
    @path = File.expand_path(given_path)

    @environment_manager = given_environment_manager
  end

  def to_s
    return @to_s if @to_s

    @to_s = "#{engine}-#{full_version}"
    @to_s += "@#{gemset}" unless gemset.empty?

    @to_s
  end
  alias inspect to_s

  def gemset
    read_ruby_gemset_file
  end

  def environment_manager_load_string
    case environment_manager
    when 'rvm'
      "rvm use #{to_s}"
    when 'rbenv'
      "RBENV_VERSION=#{to_s}"
    when 'chruby'
      "chruby-exec #{to_s} --"
    else
      raise "Unsupported environment_manager: #{environment_manager.inspect}"
    end
  end

  # comparable
  def <=>(other)
    value = case other
      when Integer
        major.to_i
      when Float
        full_version.to_f
      when String
        other_engine = extract_engine_from_string(other)

        if engine == other_engine
          other = extract_full_version_from_string(other)
          full_version
        else
          return engine <=> other_engine
        end
      else
        # A tiny bit of recursion
        return self <=> other.to_s
      end
    value <=> other
  end
  include Comparable

  # chaining for dsl-like language
  def is?(other = nil)
    if other
      self == other
    else
      self
    end
  end
  alias is is?

  # aliases
  alias below     <
  alias below?    <
  alias at_most   <=
  alias at_most?  <=
  alias above     >
  alias above?    >
  alias at_least  >=
  alias at_least? >=
  alias exactly   ==
  alias exactly?  ==
  def not(other)
    self != other
  end
  alias not?     not
  alias between between?

  # accessors
  def engine
    @engine ||= extract_engine_from_string(read_ruby_version_file)
  end

  def full_version
    @full_version ||= extract_full_version_from_string(read_ruby_version_file)
  end

  def major
    full_version.to_i
  end
  alias main major

  def minor
    full_version.split('.')[1].to_i
  end
  alias mini minor

  def tiny
    full_version.split('.')[2].to_i
  end
  alias teeny tiny

  def patchlevel
    full_version.split('-')[1].to_s
  end

  private

  def extract_engine_from_string(value)
    value = value.gsub(/\-?#{Regexp.escape(extract_full_version_from_string(value))}/, '')
    value.empty? ? 'ruby' : value
  end

  def extract_full_version_from_string(value)
    value.gsub(/\A(\D+\-p?)?/, '')
  end

  def read_ruby_version_file
    version_path = File.join(path, '.ruby-version')
    File.exists?(version_path) ? read_and_strip(version_path) : ''
  end

  def read_ruby_gemset_file
    gemset_path = File.join(path, '.ruby-gemset')
    File.exists?(gemset_path) ? read_and_strip(gemset_path) : ''
  end

  def read_and_strip(file_path)
    File.read(file_path).strip
  end
end
