require 'spec_helper'
require 'prawn'

describe "Interleave2of5" do

  before do
    @i2o5 = Interleave2of5.new("00317")
  end

  subject { @i2o5 }

  it { should respond_to(:value) }
  it { should respond_to(:options) }
  it { should respond_to(:code) }
  it { should respond_to(:graph) }

  it "should raise exception if value is not a number" do
    expect { @i2o5.value = "A" }.to raise_exception(ArgumentError)
    expect { @i2o5.value = "12a3b"}.to raise_exception(ArgumentError)
    expect { Interleave2of5.new("12a3bc4") }.
      to raise_exception(ArgumentError)
  end

  it "same digit size should result in same code size" do
    @i2o5.value = "24123"
    code_size_with_check_digit_not_0 = @i2o5.encode.code.size
    puts @i2o5
    puts code_size_with_check_digit_not_0
    @i2o5.value = "24125"
    code_size_with_check_digit_0 = @i2o5.encode.code.size
    puts @i2o5
    puts code_size_with_check_digit_0
    code_size_with_check_digit_not_0.should eq code_size_with_check_digit_0 
  end

  it "should calculate barcode value with check digit" do
    @i2o5.value = "1"
    @i2o5.encode.code.should eq "00001000000111100"
    @i2o5.code.should eq "00001000000111100"
  end

  it "should calculate barcode value without check digit" do
    @i2o5.value = "1"
    @i2o5.check = false
    @i2o5.encode.code.should eq "00000100101001100"
  end

  it "should calculate barcode graph" do
    @i2o5.value = "1"
    barcode = @i2o5.encode.barcode
    barcode.size.should eq 7
    barcode[:bars].size.should eq 9
  end

  it "should accecpt options in barcode" do
    @i2o5.encode.code.should eq "0000000011110011100000010001001110100"
    @i2o5.barcode(width: 3, height: 70, factor: 2.4).size.should eq 7
    puts @i2o5
  end

  it "should create barcode as pdf" do
    pdf = Prawn::Document.new

    puts @i2o5.encode.to_pdf(pdf).inspect
  end

  it "should check whether the decoded number is a valid barcode" do
    Interleave2of5.valid?("002127").should be true
    Interleave2of5.valid?("002128").should be false
    Interleave2of5.valid?("00212").should be false
    Interleave2of5.valid?("000212", false).should be true
  end

end
