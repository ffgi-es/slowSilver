require 'English'
require 'open3'

describe 'compiling and running program' do
  let('slwslvr') { './slwslvr' }
  let('multiline1') { File.expand_path('../fixtures/multiline1.sag', File.dirname(__FILE__)) }
  let('out_file') { 'a.out' }

  after(:example) do
    File.delete out_file if File.exist? out_file
  end

  it 'should return 4 for addition1.sag' do
    o, e, s = Open3.capture3("#{slwslvr} #{multiline1}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 27
  end
end
