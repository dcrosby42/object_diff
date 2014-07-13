require 'spec_helper'

describe "ObjectSpec" do

  def diff(a,b)
    ObjectDiff.diff(a,b)
  end
  def Diff(a,b)
    ObjectDiff::ScalarDiff.new(a,b)
  end
  def HashDiff(a,b,diffs,added={},removed={})
    ObjectDiff::HashDiff.new(a,b,diffs,added,removed)
  end
  def ArrayDiff(a,b,diffs)
    ObjectDiff::ArrayDiff.new(a,b,diffs)
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
      expect(d).to eq HashDiff(left,right,{a:Diff('A1','A2')})
    end

    it "finds new pairs" do
      left = {a:"A1"}
      right = {a:"A1", b:"B1", c:"C1"}
      d = diff(left,right)
      expect(d).to eq HashDiff(left,right,{}, {b:'B1',c:'C1'})
    end

    it "finds missing pairs" do
      left = {a:"A1", b:"B1", c:"C1"}
      right = {a:"A1"}
      d = diff(left,right)
      expect(d).to eq HashDiff(left,right,{},{}, {b:'B1',c:'C1'})
    end

    it "can handle all three cases at once" do
      left = {a:"A1", b:"B1"}
      right = {a:"A2", c:"C1"}
      d = diff(left,right)
      expect(d.a).to be(left)
      expect(d.b).to be(right)
      expect(d).to eq HashDiff(left,right,
                               {a:Diff('A1','A2')},
                               {c:'C1'}, 
                               {b:'B1'})
    end

    it "can handle Hashes in Hashes" do
      left = {h: {a: 'A1', b:'B1', k:'K'}, x:'X', z:'Z'}
      right = {h: {a: 'A2', c:'C1', k:'K'}, y:'Y', z:'Z'}
      d = diff(left,right)
      expect(d).to eq HashDiff(left,right,
                               {h: HashDiff(left[:h], right[:h],
                                            {a: Diff('A1','A2')},
                                            {c:'C1'}, 
                                            {b:'B1'})},
                               {y: 'Y'},
                               {x: 'X'})
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

    context 'same-length arrays w some diffing elements' do
      it 'works on one element' do
        a = ['A']
        b = ['B']
        expect(diff(a,b)).to eq ArrayDiff(a,b, 0 => Diff('A','B'))
      end

      it 'includes only the differing elements, keyed by their index' do
        a = [1,4,7]
        b = [1,2,3]
        expect(diff(a,b)).to eq ArrayDiff(a,b, 1 => Diff(4,2), 2 => Diff(7,3))
      end
    end

    context 'when a is longer than b' do
      it "creates x-to-nil diffs" do
        a = [1,2,3]
        b = [1,3]
        expect(diff(a,b)).to eq ArrayDiff(a,b, 1 => Diff(2,3), 2 => Diff(3,nil))
      end
    end

    context 'when a is shorter than b' do
      it "creates nil-to-x diffs" do
        a = [1,3]
        b = [1,2,3]
        expect(diff(a,b)).to eq ArrayDiff(a,b, 1 => Diff(3,2), 2 => Diff(nil,3))
      end
    end

    it 'can diff nested Hashes' do 
      a = [{a:'A', b:'B'}]
      b = [{a:'A', b:'Bee'}, {c:'C'}]
      expect(diff(a,b)).to eq ArrayDiff(a,b, 
                                        0 => HashDiff(a[0],b[0],
                                                      {b: Diff('B','Bee')}),
                                        1 => Diff(nil, {c:'C'}))
    end

    it 'can diff nested arrays' do
      a = [[1,2], [3,[4,5], [5.5]], [6]]
      b = [[1,2], [33,[44,5], [5.5]]]
      expect(diff(a,b)).to eq ArrayDiff(a,b,
                                        1 => ArrayDiff(a[1],b[1],
                                                       0 => Diff(3,33),
                                                       1 => ArrayDiff(a[1][1],b[1][1],
                                                                      0 => Diff(4,44))),
                                        2 => Diff([6], nil))
    end
  end
end
