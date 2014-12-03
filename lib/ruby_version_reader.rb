require 'date'
require 'time'

module RubyVersionReader
  VERSION = '0.1.0'

  attr_accessor :path

  def initalize(given_path)
    given_path = './' if given_path.empty?
    @path = File.expand_path(given_path)
  end

  def to_s
    read_ruby_version_file
  end
  alias inspect to_s

  def gemset
    read_ruby_gemset_file
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
    @engine ||= extract_engine_from_string(to_s)
  end

  def full_version
    @full_version ||= extract_full_version_from_string(to_s)
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
    value = value.gsub(extract_full_version_from_string(value), '')
    value.empty? : 'ruby' : value
  end

  def extract_full_version_from_string(value)
    value.gsub(/\A(\D+\-p?)?/, '').to_i
  end

  def read_ruby_version_file
    read_and_strip(File.join(path, '.ruby-version'))
  end

  def read_ruby_gemset_file
    read_and_strip(File.join(path, '.ruby-gemset'))
  end

  def read_and_strip(file_path)
    File.read(file_path).strip
  end
end
