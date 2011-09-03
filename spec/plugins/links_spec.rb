require 'spec_helper'
require 'links'

describe Links do
  describe "#prefix" do
    subject { Links.instance_variable_get '@__cinch_prefix' }

    it { should match '!link' }
    it { should match '!links' }
    it { should match '!links ' }
    it { should match '!link ' }
    it { should_not match ' !links' }
    it { should_not match '!posters' }

  end
end
