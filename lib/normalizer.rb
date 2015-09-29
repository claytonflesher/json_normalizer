require "json"

class Normalizer
  def initialize(data: )
    @json       = normalize(data: JSON.parse(data))
  end

  attr_reader :json, :exclusions
  private :exclusions

  private

  def normalize(data:, exclusions: [])
    data.delete_if { |key, value| exclusions.include?(key) }
    data.each do |key, value|
      if value.class == Array
        value.map { |element| normalize(data: element, exclusions: (exclusions + data.keys)) }
        value.delete({})
      end
    end
    data.to_json
  end
end
