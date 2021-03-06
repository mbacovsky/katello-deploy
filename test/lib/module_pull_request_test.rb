require 'test_helper'

class TestModulePullRequest < Minitest::Test

  def setup
    @module_pr = KatelloDeploy::ModulePullRequest.new(:base_path => '/tmp')
  end

  def test_prepare
    prep = sequence('prep')

    @module_pr.expects(:install_git).in_sequence(prep)
    @module_pr.expects(:setup_katello_installer).in_sequence(prep)
    @module_pr.expects(:read_puppetfile).in_sequence(prep)

    assert @module_pr.prepare
  end

  def test_setup_pull_request
    @module_pr.expects(:find_git_url).returns('https://github.com/katello/puppet-katello')
    Dir.expects(:chdir).with('/tmp/katello-installer/modules')

    assert @module_pr.setup_pull_request('katello', '1')
  end

  def test_setup_pull_request_fail
    @module_pr.expects(:find_git_url).returns(false)

    refute @module_pr.setup_pull_request('katello', '1')
  end

end
