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
    data = remove_targets(data)
    add_exclusions(data)
    data.each do |key, value|
      if value.class == Array
        value.map { |element| normalize(data: element) }
        value.delete({})
      end
    end
    data.to_json
  end

  def remove_targets(data)
    data.delete_if do |key, value|
      exclusions.select { |element| element == key }.count > 1
    end
  end

  def add_exclusions(data)
    data.each_key { |key| exclusions << key }
  end
end
