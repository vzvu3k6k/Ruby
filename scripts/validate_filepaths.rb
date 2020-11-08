# frozen_string_literal: true

require 'pathname'

class Pathname
  ALLOW_PATTERNS = Regexp.union(
    /\A[a-z0-9]+(_[a-z0-9]+)*(\.[a-z]*)?\z/,
    /\.md\z/
  )

  def valid?
    basename.to_s.match?(ALLOW_PATTERNS)
  end

  def invalid?
    !valid?
  end

  def error_message
    return nil if valid?

    %(Path: "#{pathname}" is not in snake_case.)
  end
end

# Run tests by `ruby -rminitest/autorun scripts/validate_filepaths.rb`
if defined?(Minitest)
  class TestValidation < Minitest::Test
    def test_directory_paths
      assert_predicate(Pathname('data_structures/linked_lists'), :valid?)
      assert_predicate(Pathname('data_structures/LinkedLists'), :invalid?)
      assert_predicate(Pathname('project_euler'), :valid?)
      assert_predicate(Pathname('project euler'), :invalid?)
      assert_predicate(Pathname('Project_Euler'), :invalid?)
      assert_predicate(Pathname('Project Euler'), :invalid?)
      assert_predicate(Pathname('project_euler/problem_20'), :valid?)
      assert_predicate(Pathname('project_euler/Problem 20'), :invalid?)
    end

    def test_file_paths
      assert_predicate(Pathname('other/fisher_yates.rb'), :valid?)
      assert_predicate(Pathname('other/FisherYates.rb'), :invalid?)
    end

    def test_markdown_file_paths
      assert_predicate(Pathname('README.md'), :valid?)
    end
  end

  exit
end

errors = []

Pathname.glob('**/*') do |pathname|
  if pathname.invalid?
    errors << pathname.error_message
  end
end

unless errors.empty?
  puts errors
  abort
end
