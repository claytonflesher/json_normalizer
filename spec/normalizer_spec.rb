require_relative "../lib/normalizer.rb"
require "json"

describe "Normalizer" do
  before(:each) do
    @json = {
      "wholesaler" => "US Foods",
      "delivered" =>"2015-06-19T05:15:00-0500",
      "contacts" => [
        {
          "wholesaler" => "US Foods",
          "name" => "John Lederer"
        },
        {
          "wholesaler" => "Sysco",
          "name" => "Bill Delaney"
        }
      ]
    }.to_json
    @normalizer = Normalizer.new(data: @json)
  end

  it "returns normalized json" do
    expect(@normalizer.json).to eq(
      {
        "wholesaler" => "US Foods", 
        "delivered"  => "2015-06-19T05:15:00-0500",
        "contacts"   => [
          {
            "name" => "John Lederer"
          },
          {
            "name" => "Bill Delaney"
          }
        ]
      }.to_json
    )
  end
end
