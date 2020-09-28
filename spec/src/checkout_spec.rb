require_relative '../../src/checkout.rb'

describe Checkout do
  context 'simple total calculation' do
    context 'one rule, one type, one item' do
      let(:rules) { ["A, price, 30" ] }

      it 'calculates the sum properly' do
        co = described_class.new(rules)
        co.scan("A")
        expect(co.total).to equal(30)
      end
    end
  end
end
