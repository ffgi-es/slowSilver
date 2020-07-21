require 'English'
require 'open3'

describe 'compiling and running program' do
  let('slwslvr') { './slwslvr' }
  let('sample1') { File.expand_path('../fixtures/simple_comparison1.sag', File.dirname(__FILE__)) }
  let('out_file') { 'a.out' }

  after(:example) do
    File.delete out_file if File.exist? out_file
  end

  it 'should return 1 for simple_comparison1.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample1}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 1
  end
end
