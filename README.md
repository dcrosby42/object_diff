# Object Diff #

Diff Ruby values by recursively collecting differences between Hashes, Arrays and scalar values.

# Specs #
(by running "rake spec demo=1")
<pre>
  base case:
        a = nil
        b = nil
        ObjectDiff.diff(a,b) => nil
    nils are same
        a = 0
        b = 0
        ObjectDiff.diff(a,b) => nil
    0 and 0 are same
        a = "a"
        b = "a"
        ObjectDiff.diff(a,b) => nil
    'a' and 'a' are same
        a = {}
        b = {}
        ObjectDiff.diff(a,b) => nil
    {} and {} are same
        a = {}
        b = {}
        ObjectDiff.diff(a,b) => nil
    [] and [] are same
  simple scalars:
        a = 1
        b = 2
        ObjectDiff.diff(a,b) => 1->2
    1 and 2 are different
        a = nil
        b = 2
        ObjectDiff.diff(a,b) => nil->2
    nil and 2 are different
        a = "a"
        b = "b"
        ObjectDiff.diff(a,b) => "a"->"b"
    'a' and 'b' are different
  Hash:
        a = {:a=>"A1"}
        b = {:a=>"A2"}
        ObjectDiff.diff(a,b) => {a: "A1"->"A2"}
    finds changed pairs
        a = {:a=>"A1"}
        b = {:a=>"A1", :b=>"B1", :c=>"C1"}
        ObjectDiff.diff(a,b) => {(added b: "B1", c: "C1")}
    finds new pairs
        a = {:a=>"A1", :b=>"B1", :c=>"C1"}
        b = {:a=>"A1"}
        ObjectDiff.diff(a,b) => {(removed b: "B1", c: "C1")}
    finds missing pairs
        a = {:a=>"A1", :b=>"B1"}
        b = {:a=>"A2", :c=>"C1"}
        ObjectDiff.diff(a,b) => {a: "A1"->"A2" (added c: "C1") (removed b: "B1")}
    can handle all three cases at once
        a = {:h=>{:a=>"A1", :b=>"B1", :k=>"K"}, :x=>"X", :z=>"Z"}
        b = {:h=>{:a=>"A2", :c=>"C1", :k=>"K"}, :y=>"Y", :z=>"Z"}
        ObjectDiff.diff(a,b) => {h: {a: "A1"->"A2" (added c: "C1") (removed b: "B1")} (added y: "Y") (removed x: "X")}
    can handle Hashes in Hashes
  Array:
        a = []
        b = []
        ObjectDiff.diff(a,b) => nil
    returns nil for empty lists
        a = [1, 2, 3]
        b = [1, 2, 3]
        ObjectDiff.diff(a,b) => nil
    returns nil for lists that have identical scalars
        a = [1, ["a", "b"], nil, {:x=>"X"}]
        b = [1, ["a", "b"], nil, {:x=>"X"}]
        ObjectDiff.diff(a,b) => nil
    returns nil for lists that have identical mixed content
        a = [{:a=>"A", :b=>"B"}]
        b = [{:a=>"A", :b=>"Bee"}, {:c=>"C"}]
        ObjectDiff.diff(a,b) => [0: {b: "B"->"Bee"}, 1: nil->{:c=>"C"}]
    can diff nested Hashes
        a = [[1, 2], [3, [4, 5], [5.5]], [6]]
        b = [[1, 2], [33, [44, 5], [5.5]]]
        ObjectDiff.diff(a,b) => [1: [0: 3->33, 1: [0: 4->44]], 2: [6]->nil]
    can diff nested arrays
    same-length arrays w some diffing elements
        a = ["A"]
        b = ["B"]
        ObjectDiff.diff(a,b) => [0: "A"->"B"]
      works on one element
        a = [1, 4, 7]
        b = [1, 2, 3]
        ObjectDiff.diff(a,b) => [1: 4->2, 2: 7->3]
      includes only the differing elements, keyed by their index
    when a is longer than b
        a = [1, 2, 3]
        b = [1, 3]
        ObjectDiff.diff(a,b) => [1: 2->3, 2: 3->nil]
      creates x-to-nil diffs
    when a is shorter than b
        a = [1, 3]
        b = [1, 2, 3]
        ObjectDiff.diff(a,b) => [1: 3->2, 2: nil->3]
      creates nil-to-x diffs
      </pre>

## Other interesting Ruby object diffing libs ##

* easy_diff - https://github.com/Blargel/easy_diff - recursive hash diffing - GOOD
* difference -https://github.com/manishspuri/difference - ActiveRecord diffing
* diffr - https://github.com/mattsears/diffr - simple hash diffing 


  

