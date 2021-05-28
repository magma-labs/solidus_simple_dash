# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusSimpleDash::Configuration do
  it 'can be instantiated' do
    expect { described_class.new }.not_to raise_error
  end

  it 'allows registering custom events' do
    configuration = described_class.new
    configuration.limit = 5
    expect(configuration.limit).to eq(5)
  end
end
