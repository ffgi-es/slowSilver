require 'English'
require 'open3'

describe 'compiling and running program' do
  let('slwslvr') { './slwslvr' }
  let('sample1') { File.expand_path('../fixtures/params_matching1.sag', File.dirname(__FILE__)) }
  let('sample2') { File.expand_path('../fixtures/params_matching2.sag', File.dirname(__FILE__)) }
  let('sample3') { File.expand_path('../fixtures/params_matching3.sag', File.dirname(__FILE__)) }
  let('sample4') { File.expand_path('../fixtures/params_matching4.sag', File.dirname(__FILE__)) }
  let('sample5') { File.expand_path('../fixtures/params_matching5.sag', File.dirname(__FILE__)) }
  let('sample6') do
    File.expand_path('../fixtures/mixed_param_matching.sag', File.dirname(__FILE__))
  end
  let('out_file') { 'a.out' }

  after(:example) do
    File.delete out_file if File.exist? out_file
  end

  it 'should return 13 for params_matching1.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample1}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 13
  end

  it 'should return 21 for params_matching2.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample2}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 21
  end

  it 'should return 28 for params_matching3.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample3}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 28
  end

  it 'should return 24 for params_matching4.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample4}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 24
  end

  it 'should return 1 for params_matching5.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample5}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 1
  end

  it 'should return 55 for mixed_param_matching.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample6}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 89
  end
end
