require "rspec/autorun"

class Nucleotide
  attr_reader :dna_string

  def initialize(dna_string)
    raise ArgumentError unless dna_string.count("^ACGT").zero?
    @dna_string = dna_string
  end

  def self.from_dna(dna_string)
    new(dna_string)
  end

  def histogram
    strands = ["A", "T", "C", "G"]
    strands.each_with_object({}) do |character, hash|
      hash[character] = count(character)
    end
  end

  def count(letter)
    dna_string.chars.count { |charachter| charachter == letter }
  end
end

RSpec.describe Nucleotide do
  it "empty dna strand has no adenosine" do
    expect(described_class.from_dna('').count('A')).to eq 0
  end

  it "repetitive ytidine gets counted" do
   expect(described_class.from_dna('CCCCC').count('C')).to eq 5
  end

  it "counts only thymidine" do
    expect(described_class.from_dna('GGGGGTAACCCGG').count('T')).to eq 1
  end

  it "counts a nucleotide only once" do
    dna = Nucleotide.from_dna('CGATTGGG')
    dna.count('T')
    dna.count('T')

    expect(dna.count('T')).to eq 2
  end

  it "empty dna strand has no nucleotides" do
    expected = { 'A' => 0, 'T' => 0, 'C' => 0, 'G' => 0 }

    expect(described_class.from_dna('').histogram).to eq expected
  end

  it "repetitive sequence has only guanosine" do
    expected = { 'A' => 0, 'T' => 0, 'C' => 0, 'G' => 8 }

    expect(described_class.from_dna('GGGGGGGG').histogram).to eq expected
  end

  it "counts all nucleotides" do
    s = 'AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC'
    dna = Nucleotide.from_dna(s)
    expected = { 'A' => 20, 'T' => 21, 'G' => 17, 'C' => 12 }

    expect(dna.histogram).to eq expected
  end

  it "validates dna" do
    expect {
      Nucleotide.from_dna('JOHNNYAPPLESEED')
    }.to raise_error(ArgumentError)
  end
end
