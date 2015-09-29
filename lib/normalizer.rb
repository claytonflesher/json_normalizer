require "json"

class Normalizer
  def initialize(data: )
    @parsed     = JSON.parse(data)
    @exclusions = @parsed.keys
    @json       = normalize(data: @parsed)
  end

  attr_reader :json, :exclusions
  private :exclusions

  private

  def normalize(data:)
    data.delete_if do |key, value|
      exclusions.select { |element| element == key }.count > 1
    end
    data.each_key { |key| exclusions << key }
    data.each do |key, value|
      if value.class == Array
        value.map { |element| normalize(data: element) }
        value.delete({})
      end
    end
    data.to_json
  end
end
