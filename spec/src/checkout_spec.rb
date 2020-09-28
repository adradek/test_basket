require_relative '../../src/checkout.rb'

describe Checkout do
  context 'without doscoutns' do
    context 'one rule, one type' do
      let(:rules) { ["A, price, 30" ] }

      context 'one item' do
        it 'calculates the sum properly' do
          co = described_class.new(rules)
          co.scan("A")
          expect(co.total).to equal(30)
        end
      end

      context 'several items' do
        it 'calculates the sum properly' do
          co = described_class.new(rules)
          3.times { co.scan("A") }
          expect(co.total).to equal(90)
        end
      end
    end

    context 'one rule, several types' do
      let(:rules) { [ "A, price, 30" ] }

      it 'ignores Bs, Cs and other Ds' do
        co = described_class.new(rules)
        co.feed("A A B C B C D")
        expect(co.total).to equal(60)
      end
    end

    context 'all prices specified' do
      let(:rules) do
        [
          "A, price, 30",
          "B, price, 20",
          "C, price, 50",
          "D, price, 15",
        ]
      end

      it 'calculates total properly' do
        co = described_class.new(rules)
        co.feed("A A B C B D B")
        expect(co.total).to equal(2 * 30 + 3 * 20 + 50 + 15)
      end
    end
  end

  context 'with discounts' do
    context 'only'
  end
end
