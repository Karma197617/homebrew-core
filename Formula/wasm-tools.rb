class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.18.tar.gz"
  sha256 "20d771b04bddb09fafbf82e1d8e124135bd3422f48f976e48f1599bea79cb3b9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ad734967f4c2f4c958c7c370a63433fa9dfa38c9900b6689a731f5d61178e8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e772e51fd038cdaccd0dfc47ce6cde250ad81300d2c6cd9caf272ddab9eb23f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4951aa46178d7851e5a39940e282898391b3a6591eaebbc5769899511f5077c3"
    sha256 cellar: :any_skip_relocation, ventura:        "5b7780bbe89e3300be1eecd417716aacc13d8e7695d3a23029d69bf405ccc688"
    sha256 cellar: :any_skip_relocation, monterey:       "80b52e4967ce6ea28073e4c4121dd9a75b05cc7f442a807ccdc9acc8774675e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a9295f3c8b36dfdd499772fda31c67f79a07d25c77ad1612e2901b59bcd948b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b1512ec14644721b52ea2efd811d688c3fe40791a377e048c5aa369c725ccb6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS.strip
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
        (export "sum" (func 0))
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end
