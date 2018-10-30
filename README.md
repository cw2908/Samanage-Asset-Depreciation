Asset Depreciation Script


This script is an example provided and is not designed to work in every use case without some modification to the script itself. These script is not supported by Samanage or covered by Master Subscription Agreement. 



### To Run
 
  - Install Ruby 2.3+
  - Install Samanage gem: `gem install samanage`
  - Run the command: `ruby calculate_depreciation.rb API_TOKEN` to calculate new depreciation (`ruby calculate_depreciation.rb API_TOKEN eu` for the European database)


  For all assets with custom fields `Purchase Date`, `Cost`, `Asset Life (in years)` a new depreciation will be calculated using the formula: `Cost - (Cost / Asset Life * 12) * (Months Passed)`


```ruby
# Input
  cost = 12000
  purchase_date = Date.parse('2018-01-01')
  asset_life = 2 # Asset Life in Years
  current_date = Date.parse('2018-06-01')


# Output
result = { 
  'Months Passed' => current - purchase_date
  'Depreciation Expense' => cost / asset_life,
  'Accumulated Depreciation' => depreciation_expense * months_passed,
  'Net Book Value' => cost - accumulated_depreciation
}

 # => {
 #    'Months Passed' => 5,
 #    'Depreciation Expense' => '500',
 #    'Accumulated Depreciation' =>  '2,500'
 #    'Net Book Value' => '9,500'
 #  }

```
