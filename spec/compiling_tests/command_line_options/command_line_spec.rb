require 'English'
require 'open3'

describe 'compiling and running program' do
  let('slwslvr') { './slwslvr' }
  let('sample1') { File.expand_path('sample1.sag', File.dirname(__FILE__)) }
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
                - int: 3
                - int: 2
    OUTPUT
    expect(o).to eq expected_output
  end
end
