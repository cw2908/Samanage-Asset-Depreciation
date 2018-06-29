# Samanage Asset Depreciation Script

### To Run
 
  - Install Ruby 2.3
  - Install Samanage gem: `gem install samanage`
  - Run the command: `ruby calculate_depreciation.rb API_TOKEN` to calculate new depreciation


  For all assets with custom fields `Purchase Date`, `Cost`, `Asset Life (in years)` a new depreciation will be calculated using the formula: `Cost - (Cost / Asset Life * 12) * (Months Passed)`
