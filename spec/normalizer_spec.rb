require_relative "../lib/normalizer.rb"
require "json"

describe "Normalizer" do
  it "returns removes pairs whose key occurs at higher levels" do
    json = {
      "wholesaler" => "US Foods",
      "delivered" => "2015-06-19T05:15:00-0500",
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
    normalizer = Normalizer.new(data: json)

    expect(normalizer.json).to eq(
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

  it "accounts for key names that aren't in the top layer" do
    json = {
      "wholesaler" => "US Foods",
      "delivered" => "2015-06-19T05:15:00-0500",
      "contacts" => [
        {
          "name" => [
            {
              "name" => "Something"
            }
          ]
        }
      ]
    }.to_json
    normalizer = Normalizer.new(data: json)

    expect(normalizer.json).to eq(
      {
        "wholesaler" => "US Foods",
        "delivered"  => "2015-06-19T05:15:00-0500",
        "contacts"   => [
          {
            "name" => []
          }
        ]
      }.to_json
    )
  end
end
