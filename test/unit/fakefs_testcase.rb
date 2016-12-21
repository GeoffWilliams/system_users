module FakeFSTestcase
  def self.testcase_path(testcase)
    config = File.realpath(
      File.dirname(File.expand_path(__FILE__)) +
      '/../fixtures/fakefs/' + testcase
    )
  end

  def self.activate_testcase(testcase)

    # on entry to this function the helper will have already enabled fakefs but
    # we must deactivate it now to check that the files we want exist on the
    # system or we will be checking the fakeFS and not the real one...
    FakeFS.deactivate!
    config = testcase_path(testcase)

    if File.directory?(config)
      # files are in place, activate fakefs and clone into the active FS
      FakeFS.activate!
      FakeFS::FileSystem.clone(config, '/')
    else
      raise "testcase directory for #{testcase} not found at #{config}"
    end
  end
end
