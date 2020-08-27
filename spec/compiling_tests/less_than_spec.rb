require 'English'
require 'open3'

describe 'compiling and running program' do
  let('slwslvr') { './slwslvr' }
  let('sample1') { File.expand_path('../fixtures/less_than1.sag', File.dirname(__FILE__)) }
  let('sample2') { File.expand_path('../fixtures/less_than2.sag', File.dirname(__FILE__)) }
  let('sample3') { File.expand_path('../fixtures/less_than3.sag', File.dirname(__FILE__)) }
  let('sample4') { File.expand_path('../fixtures/less_than_equal1.sag', File.dirname(__FILE__)) }
  let('sample5') { File.expand_path('../fixtures/less_than_equal2.sag', File.dirname(__FILE__)) }
  let('sample6') { File.expand_path('../fixtures/less_than_equal3.sag', File.dirname(__FILE__)) }
  let('out_file') { 'a.out' }

  after(:example) do
    File.delete out_file if File.exist? out_file
  end

  it 'should return 1 for less_than1.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample1}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 1
  end

  it 'should return 0 for less_than2.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample2}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 0
  end

  it 'should return 0 for less_than3.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample3}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 0
  end

  it 'should return 1 for less_than_equal1.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample4}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 1
  end

  it 'should return 1 for less_than_equal2.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample5}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 1
  end

  it 'should return 0 for less_than_equal3.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample6}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 0
  end
end
