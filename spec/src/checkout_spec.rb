require_relative '../../src/checkout.rb'

describe Checkout do
  context 'without discoutns' do
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
    let(:rules) do
      [
        "A, price, 30",
        "B, price, 20",
        "C, price, 50",
        "D, price, 15"
      ]
    end

    context 'multi-buy discounts only' do
      before { rules << "A, quantitive discount, 3, 15" }

      it "gives the discount if the condition is met" do
        co = described_class.new(rules)
        co.feed("A A A")
        expect(co.total).to equal(3 * 30 - 15)
      end

      it "doesn't give the discount if the condition not met" do
        co = described_class.new(rules)
        co.feed("A A")
        expect(co.total).to equal(2 * 30)
      end

      it "multyplies the discount if the condition is met several times" do
        co = described_class.new(rules)
        co.feed("A A A A A A A A A A")  # ten As
        expect(co.total).to equal(10 * 30 - 3 * 15)
      end
    end
  end

  context 'control tests (provided by client)' do
    let(:rules) do
      [
        "A, price, 30",
        "B, price, 20",
        "C, price, 50",
        "D, price, 15",
        "A, quantitive discount, 3, 15",
        "B, quantitive discount, 2, 5",
        "total, total discount, 150, 20"
      ]
    end

    {
      "A, B, C" => 100,
      "B, A, B, A, A" => 110,
      "C, B, A, A, D, A, B" => 155,
      "C, A, D, A, A" => 140

    }.each do |items, proper_sum|
      it "calculates the total properly for #{items} set" do
        co = Checkout.new(rules)
        items.split(",").map(&:strip).each { |item| co.scan(item) }
        expect(co.total).to equal(proper_sum)
      end
    end
  end
end
