# Check for whether this workaround is necessary
# See: https://github.com/jimweirich/rspec-given/pull/43
if Gem::Version.new(::Given::VERSION) > Gem::Version.new('3.5.4')
  raise 'This may no longer be needed'
end

RSpec::Given::HaveFailed::HaveFailedMatcher.class_eval do
  def wrapped(given)
    given.is_a?(::Given::Failure) ? -> { given.call } : -> { }
  end

  def matches?(given_proc, negative_expectation = false)
    super(wrapped(given_proc), negative_expectation)
  end

  def does_not_match?(given_proc)
    super(wrapped(given_proc))
  end
end
