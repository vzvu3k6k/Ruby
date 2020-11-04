# frozen_string_literal: true

allow_patterns = Regexp.union(
  /\A[a-z0-9]+(_[a-z0-9]+)*(\.[a-z]*)?\z/,
  /\.md\z/
)

errors = []

Dir.glob('**/*') do |path|
  unless File.basename(path).match?(allow_patterns)
    errors << %(Path: "#{path}" is not in snake_case.)
  end
end

unless errors.empty?
  puts errors
  abort
end
