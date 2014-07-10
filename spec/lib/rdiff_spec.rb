require 'spec_helper'

describe "rdiff" do
  def diff(a,b)
    Rdiff.diff(a,b)
  end
  def Diff(a,b)
    Rdiff::Diff.new(a,b)
  end

  describe "base case:" do
    it "nils are same" do
      expect(diff(nil,nil)).to be nil
    end

    it "0 and 0 are same" do
      expect(diff(0,0)).to be nil
    end

    it "'a' and 'a' are same" do
      expect(diff("a","a")).to be nil
    end

    it "{} and {} are same" do
      expect(diff({},{})).to be nil
    end
    it "[] and [] are same" do
      expect(diff({},{})).to be nil
    end
  end

  describe "simple scalars:" do
    it "1 and 2 are different" do
      d = diff(1,2)
      expect(d).to eq Diff(1,2)
    end
    it "nil and 2 are different" do
      d = diff(nil,2)
      expect(d).to eq Diff(nil,2)
    end
    it "'a' and 'b' are different" do
      d = diff('a','b')
      expect(d).to eq Diff('a','b')
    end
  end

  describe "Hash:" do
    it "finds changed keys" do
      d = diff({a:"A1"},{a:"A2"})
      p d
      expect(d).to eq nil
    end
  end

  describe "Array:" do
  end
end
