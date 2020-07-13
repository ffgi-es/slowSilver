describe "compiling and running program" do
  let("slwslvr") { "./slwslvr" }
  let("sample") { File.expand_path("sample.sag", File.dirname(__FILE__)) }
  let("out_file") { "a.out" }

  after(:example) do
    File.delete out_file if File.exists? out_file
  end

  it "should return 2" do
    `#{slwslvr} #{sample}`
    expect($?.exitstatus).to be 0
    `./#{out_file}`
    expect($?.exitstatus).to be 2
  end

  it "should delete its temporary files" do
    `#{slwslvr} #{sample}`
    expect(Dir['*.asm']).to be_empty
    expect(Dir['*.o']).to be_empty
  end
end
