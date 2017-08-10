````
require_relative('path to radix_tree.rb')
````
````
rt = RadixTree.new([{'test' => '1'}, {'slow' => '2'}, {'water' => '3'}])
rt.add('slower', 4)
````

````
rt.has?('slow') => true
rt.has?('slower') => true

rt.value_for('slow') => '3'
rt.value_for('slower) => 4
````

````
rt.to_h => {"test"=>"1", "slow"=>"2", "water"=>"3", "slower"=> 4}
````
