require_relative 'shared'

describe 'integer return compiler tests' do
  include_context 'compiling test'

  [
    ['integer_return1.sag', 2],
    ['integer_return2.sag', 3]
  ]
    .each { |(file, exit_code)| include_examples 'exit code', file, exit_code }

  let('sample1') { File.expand_path('../fixtures/integer_return1.sag', File.dirname(__FILE__)) }
  let('sample2') do
    File.expand_path('../fixtures/integer_return_fail1.sag', File.dirname(__FILE__))
  end

  it 'should delete its temporary files' do
    `#{slwslvr} #{sample1}`
    expect(Dir['*.asm']).to be_empty
    expect(Dir['*.o']).to be_empty
  end

  it 'should output an error to stderr' do
    o, e, s = Open3.capture3("#{slwslvr} #{sample2}")
    expect(s.exitstatus).to eq 1
    expect(e).to eq "parsing error\n"
    expect(o).to be_empty
  end
end
