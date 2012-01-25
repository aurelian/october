require 'typhoeus'

class Hudson
  include October::Plugin

  autoload :Fetcher, 'hudson/fetcher'
  autoload :Reporter, 'hudson/reporter'
  autoload :TestRun, 'hudson/test_run'

  HYDRA = Typhoeus::Hydra.new

  FAILED = /(?:failures|failed|f)/
  BUILD = /(?:\/(\d+))?/
  JOB = /(\w+?)/

  match /#{FAILED} #{JOB}#{BUILD}$/, method: :failures
  match /(?:failures|failed|f) #{JOB}#{BUILD} diff #{JOB}#{BUILD}$/, method: :diff

  register_help 'failures|failed|f project', 'list failed tests (cukes and test units) from last test run'
  register_help 'failures|failed|f project/test_number', 'list failed tests from specific test run'
  register_help 'failures|failed|f project/test_number diff another/test', 'list only difference between these two tests'

  def failures(m, project, test_run = nil)
    test = TestRun.new project, test_run
    reporter = Reporter.new test

    reporter.respond :report, m
  end

  def diff(m, *projects)
    tests = projects.in_groups_of(2).map {|project, number|
      TestRun.new project, number
    }
    reporter = Reporter.new *tests

    reporter.respond :diff, m
  end

end
