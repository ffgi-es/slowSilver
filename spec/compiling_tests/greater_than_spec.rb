require 'English'
require 'open3'

describe 'compiling and running program' do
  let('slwslvr') { './slwslvr' }
  let('sample1') { File.expand_path('../fixtures/greater_than1.sag', File.dirname(__FILE__)) }
  let('sample2') { File.expand_path('../fixtures/greater_than2.sag', File.dirname(__FILE__)) }
  let('sample3') { File.expand_path('../fixtures/greater_than3.sag', File.dirname(__FILE__)) }
  let('out_file') { 'a.out' }

  after(:example) do
    File.delete out_file if File.exist? out_file
  end

  it 'should return 1 for greater_than1.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample1}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 1
  end

  it 'should return 0 for greater_than2.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample2}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 0
  end

  it 'should return 0 for greater_than3.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample3}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 0
  end
end
