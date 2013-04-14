require 'spec_helper'

require 'hamster/set'

describe Hamster::Set do

  describe "#marshal_dump/#marshal_load" do

    let (:ruby) { File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name']) }

    let (:child_cmd) {
      %Q|#{ruby} -I lib -r hamster -e 'set = Hamster.set :one, :two; $stdout.write(Marshal.dump(set))'|
    }

    let (:reloaded_hash) {
      IO.popen(child_cmd, 'r+') { |child|
        reloaded_hash = Marshal.load(child)
        child.close
        reloaded_hash
      }
    }

    it "should survive dumping and loading into a new process" do
      reloaded_hash.should == Hamster.set(:one, :two)
    end

    it "should still be possible to test items by key" do
      reloaded_hash.should include :one
      reloaded_hash.should include :two
    end

  end

end
