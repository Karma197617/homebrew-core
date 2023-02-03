class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.22.tar.gz"
  sha256 "92f1385e86be2121ad43ab071833e7269dd874e1fe44f33f215131d017f9f840"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ebad7f5c4d88d5b890dd6f265ec01aa9d64b1aa60b0c294d1deee34c81a85ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98d0878266417a76f18c1d1b66e346d54c72f6a7e7283cca18efa5acdf21c8e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3ed43ec1d3cf07059a140dd1c921dfbcbc98b7010aab5f7d270ae4a4577b31d"
    sha256 cellar: :any_skip_relocation, ventura:        "916a4387720a0639525e58b6c430b0822cd97be2468559af695fdfd98cd8e715"
    sha256 cellar: :any_skip_relocation, monterey:       "bb6de0ff9f0d6c78f047c9b12003ced0a279eec53d1c51454f7ed398d390fa6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d1fd3bcfc75eeaf912303ded2d70e6a3e2696ed29fc30fd3bcb1ddd20e30a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc2ca0e42347c68e67c5aa84bd24f22c3324aa989773f66d8e8e279d5c0a9dd2"
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
