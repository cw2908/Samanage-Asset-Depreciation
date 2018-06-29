require 'samanage'

api_token = ARGV[0]
datacenter = ARGV[1]
unless api_token 
  puts "Please enter an API Token\n\n\n> ruby calculate_depreciation.rb SAMANAGE_API_TOKEN"
  exit
end
@samanage = Samanage::Api.new(token: api_token, datacenter: datacenter)


class Array
  # Select custom field value by name
  def find_custom_field_value name
    self.select{ |field| field['name'] == name }.first.to_h.dig('value')
  end
end

class String
  # Format commas
  def format_number
    self.reverse.gsub(/\d{3}(?=.)/,'\&,').reverse
  end
end


def calculate_depreciation other_asset
  current_date = Date.today
  custom_fields = other_asset.dig('custom_fields_values')
  begin
    purchase_date = Date.parse(custom_fields.find_custom_field_value('Purchase Date'))
  rescue => e
    # Return if there is no purchase date
    # puts "#{e.class} - #{e.inspect}"
    return
  end

  asset_name = other_asset.dig('name'),
  cost = custom_fields.find_custom_field_value('Cost')
  asset_life = custom_fields.find_custom_field_value('Asset Life')
  return unless cost && asset_life # return if there is no cost or Assef Life
  
  depreciation_expense =  sprintf("%.2f",cost.to_f / (asset_life.to_i * 12)).to_f
  months_passed = (current_date.year * 12 + current_date.month) - (purchase_date.year * 12 + purchase_date.month)
  if months_passed >= asset_life.to_i * 12
    new_depreciation_values = {
      name: asset_name,
      accumulated_depreciation: sprintf("%.2f",cost).format_number,
      depreciation_expense: sprintf("%.2f",depreciation_expense).format_number,
      net_book_value: sprintf("%.2f",'0.0').format_number,
      current_date: current_date.strftime("%b %d %Y")
    }  
  else
    accumulated_depreciation = depreciation_expense * months_passed
    net_book_value = cost.to_f - accumulated_depreciation
    new_depreciation_values = {
      name: asset_name,
      accumulated_depreciation: sprintf("%.2f",accumulated_depreciation).format_number,
      depreciation_expense: sprintf("%.2f",depreciation_expense).format_number,
      net_book_value: sprintf("%.2f",net_book_value).format_number,
      current_date: current_date.strftime("%b %d %Y")
    }  
  end
end


@samanage.other_assets {|other_asset| 
  new_depreciation_values = calculate_depreciation(other_asset)
  unless new_depreciation_values
    puts "Skiping #{other_asset['name']} - invalid data #{other_asset['href'].gsub('.json','')}"
    next 
  end
  puts "Updating #{new_depreciation_values[:name]} - #{other_asset['href'].gsub('.json','')}"
  @samanage.update_other_asset(id: other_asset['id'], payload: {
    other_asset: {
      custom_fields_values: {
        custom_fields_value: [
          {name: 'Net Book Value', value: new_depreciation_values[:net_book_value]},
          {name: 'Accumulated Depreciation', value: new_depreciation_values[:accumulated_depreciation]},
          {name: 'Depreciation Expense', value: new_depreciation_values[:depreciation_expense]}
        ]
      }
    }
  })


}