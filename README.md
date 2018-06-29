# Samanage Asset Depreciation Script

### To Run
 
  Install Ruby 2.3 and samanage gem (`gem install samanage`) then run the command: `ruby calculate_depreciation.rb API_TOKEN`


  For all assets with custom fields `Purchase Date`, `Cost`, `Asset Life` a new depreciation will be calculated using the formula: `Cost - (Cost / Asset Life * 12) * (Months Passed)`