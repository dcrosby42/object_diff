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
    it "finds changed pairs" do
      left = {a:"A1"}
      right = {a:"A2"}
      d = diff(left,right)
      expect(d.a).to be(left)
      expect(d.b).to be(right)
      expect(d.diffs).to eq({a: Diff('A1', 'A2') })
      expect(d.added).to eq({})
      expect(d.removed).to eq({})
    end

    it "finds new pairs" do
      left = {a:"A1"}
      right = {a:"A1", b:"B1", c:"C1"}
      d = diff(left,right)
      expect(d.a).to be(left)
      expect(d.b).to be(right)
      expect(d.diffs).to eq({})
      expect(d.added).to eq(b:'B1',c:"C1")
      expect(d.removed).to eq({})
    end

    it "finds missing pairs" do
      left = {a:"A1", b:"B1", c:"C1"}
      right = {a:"A1"}
      d = diff(left,right)
      expect(d.a).to be(left)
      expect(d.b).to be(right)
      expect(d.diffs).to eq({})
      expect(d.added).to eq({})
      expect(d.removed).to eq(b:'B1',c:"C1")
    end

    it "can handle all three cases at once" do
      left = {a:"A1", b:"B1"}
      right = {a:"A2", c:"C1"}
      d = diff(left,right)
      expect(d.a).to be(left)
      expect(d.b).to be(right)
      expect(d.diffs).to eq({a: Diff('A1','A2')})
      expect(d.added).to eq({c: "C1"})
      expect(d.removed).to eq(b:'B1')
    end

    it "can handle Hashes in Hashes" do
      left = {h: {a: 'A1', b:'B1', k:'K'}, x:'X', z:'Z'}
      right = {h: {a: 'A2', c:'C1', k:'K'}, y:'Y', z:'Z'}
      d = diff(left,right)
      expect(d.a).to be(left)
      expect(d.b).to be(right)

      hd = d.diffs[:h]
      expect(hd.a).to be(left[:h])
      expect(hd.b).to be(right[:h])
      expect(hd.diffs).to eq({a: Diff('A1','A2')})
      expect(hd.added).to eq({c:"C1"})
      expect(hd.removed).to eq(b:'B1')
      
      expect(d.added).to eq(y: 'Y')
      expect(d.removed).to eq(x: 'X')
    end
  end

  describe "Array:" do
    it 'returns nil for empty lists' do
      expect(diff([],[])).to be nil
    end

    it 'returns nil for lists that have identical scalars' do
      a = [1,2,3]
      b = [1,2,3]
      expect(diff(a,b)).to be nil
    end

    it 'returns nil for lists that have identical mixed content' do
      a = [1,['a','b'],nil,{x:'X'}]
      b = [1,['a','b'],nil,{x:'X'}]
      expect(diff(a,b)).to be nil
    end

    it 'walks through the arrays side-by-side to discover diffs'
    it 'works when a is longer than b'
    it 'works when a is shorter than b'
  end
end
