require 'English'
require 'open3'

describe 'compiling and running program' do
  let('slwslvr') { './slwslvr' }
  let('sample1') { File.expand_path('../fixtures/function1.sag', File.dirname(__FILE__)) }
  let('sample2') { File.expand_path('../fixtures/function2.sag', File.dirname(__FILE__)) }
  let('sample3') { File.expand_path('../fixtures/function3.sag', File.dirname(__FILE__)) }
  let('sample4') { File.expand_path('../fixtures/function4.sag', File.dirname(__FILE__)) }
  let('sample5') { File.expand_path('../fixtures/nested_functions1.sag', File.dirname(__FILE__)) }
  let('sample6') { File.expand_path('../fixtures/nested_functions2.sag', File.dirname(__FILE__)) }
  let('out_file') { 'a.out' }

  after(:example) do
    File.delete out_file if File.exist? out_file
  end

  it 'should return 7 for function1.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample1}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 7
  end

  it 'should return 8 for function2.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample2}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 8
  end

  it 'should return 11 for function3.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample3}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 11
  end

  it 'should return 9 for function4.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample4}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 9
  end

  it 'should return 11 for nested_functions1.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample5}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 11
  end

  it 'should return 25 for nested_functions2.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample6}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 25
  end
end
