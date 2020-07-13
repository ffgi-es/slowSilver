describe "compiling and running program" do
  let("slwslvr") { "./slwslvr" }
  let("sample") { File.expand_path("sample.sag", File.dirname(__FILE__)) }

  it "should return 2" do
    `#{slwslvr} #{sample}`
    expect($?.exitstatus).to be 0
    `./a.out`
    expect($?.exitstatus).to be 2
  end
end
