require 'English'
require 'open3'

shared_context 'compiling test' do
  let('slwslvr') { './slwslvr' }
  let('out_file') { 'a.out' }

  after(:example) do
    File.delete out_file if File.exist? out_file
  end
end

shared_examples 'exit code' do |file, exit_code|
  it "should return #{exit_code} for #{file}" do
    path = File.expand_path("../fixtures/#{file}", File.dirname(__FILE__)) 

    o, e, s = Open3.capture3("#{slwslvr} #{path}")

    puts e if s.exitstatus != 0
    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq exit_code
  end
end
