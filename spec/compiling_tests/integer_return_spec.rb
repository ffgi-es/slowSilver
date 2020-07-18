require 'English'
require 'open3'

describe 'compiling and running program' do
  let('slwslvr') { './slwslvr' }
  let('sample') { File.expand_path('../fixtures/integer_return1.sag', File.dirname(__FILE__)) }
  let('sample2') { File.expand_path('../fixtures/integer_return2.sag', File.dirname(__FILE__)) }
  let('fail1') { File.expand_path('../fixtures/integer_return_fail1.sag', File.dirname(__FILE__)) }
  let('out_file') { 'a.out' }

  after(:example) do
    File.delete out_file if File.exist? out_file
  end

  it 'should return 2' do
    `#{slwslvr} #{sample}`
    expect($CHILD_STATUS.exitstatus).to eq 0
    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 2
  end

  it 'should delete its temporary files' do
    `#{slwslvr} #{sample}`
    expect(Dir['*.asm']).to be_empty
    expect(Dir['*.o']).to be_empty
  end

  it 'should not output any errors for correct examples' do
    output = `#{slwslvr} #{sample} 2>&1`
    expect($CHILD_STATUS.exitstatus).to eq 0
    expect(output).to be_empty
  end

  it 'should return 3' do
    `#{slwslvr} #{sample2}`
    expect($CHILD_STATUS.exitstatus).to eq 0
    `./#{out_file}`
    expect($CHILD_STATUS.exitstatus).to eq 3
  end

  it 'should output an error to stderr' do
    o, e, s = Open3.capture3("#{slwslvr} #{fail1}")
    expect(s.exitstatus).to eq 1
    expect(e).to eq "parsing error\n"
    expect(o).to be_empty
  end
end
