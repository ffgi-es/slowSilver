require 'English'
require 'open3'

describe 'compiling and running program' do
  let('slwslvr') { './slwslvr' }
  let('sample1') { File.expand_path('../fixtures/addition1.sag', File.dirname(__FILE__)) }
  let('out_file') { 'a.out' }

  after(:example) do
    File.delete out_file if File.exist? out_file
  end

  it "should print the AST with '-ast' option" do
    o, e, s = Open3.capture3("#{slwslvr} -ast #{sample1}")

    expect(s.exitstatus).to eq 0
    expect(e).to be_empty

    expected_output = <<~OUTPUT
      program:
        - func:
          - name: 'main'
          - return:
            - call:
              - name: +
              - params:
                - int: 2
                - int: 2
    OUTPUT
    expect(o).to eq expected_output
  end

  it "should leave the assembly file with '-nd' option" do
    o, e, s = Open3.capture3("#{slwslvr} -nd #{sample1}")

    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    expect(Dir['addition1.asm']).not_to be_empty

    File.delete 'addition1.asm' if File.exist? 'addition1.asm'
  end

  it "should leave the assembly file with '-nd' option at the end" do
    o, e, s = Open3.capture3("#{slwslvr} #{sample1} -nd")

    expect(s.exitstatus).to eq 0
    expect(e).to be_empty
    expect(o).to be_empty

    expect(Dir['addition1.asm']).not_to be_empty

    File.delete 'addition1.asm' if File.exist? 'addition1.asm'
  end
end