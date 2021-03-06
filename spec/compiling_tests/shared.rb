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
    _, _, stat = compile_and_run file, slwslvr, out_file
    expect(stat.exitstatus).to eq exit_code
  end
end

shared_examples 'output' do |file, exit_code, output|
  it "should return print '#{output}' for #{file}" do
    out, err, stat = compile_and_run file, slwslvr, out_file
    expect(err).to be_empty
    expect(stat.exitstatus).to eq exit_code
    expect(out).to eq output
  end
end

shared_examples 'error' do |file, error_msg|
  it "should output '#{error_msg}' for #{file}" do
    _, err, status = compile file, slwslvr

    expect(status.exitstatus).not_to be 0
    expect(err).to eq error_msg
  end
end

def compile(file, compiler)
  path = File.expand_path("../fixtures/#{file}", File.dirname(__FILE__))

  Open3.capture3("#{compiler} #{path}")
end

def compile_and_run(file, compiler, executeable)
  o, e, s = compile(file, compiler)

  puts e if s.exitstatus != 0
  expect(s.exitstatus).to eq 0
  expect(e).to be_empty
  expect(o).to be_empty

  Open3.capture3("./#{executeable}")
end
