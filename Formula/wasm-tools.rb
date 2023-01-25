class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.19.tar.gz"
  sha256 "1cf6a70bf391258e2d4e869a333ffd7be4f7338ac2306eef3ac1ea5695b60b2b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bd7fc28b70c53cb9dcbee7d5cdbc33a28efe89efd0efba03921f02b7defe9d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c102055e9e0bcfb26cc3337b376ffce2853cf67211a1931de1720fad357ef37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cc3b1ab029e5c292a78b583f82146a86f60a7e61e11aee449042ca615f411bd"
    sha256 cellar: :any_skip_relocation, ventura:        "46558415de7a2d324f6b72664d0d4a9dd677b9d641899c9ce2aad38a88adf41d"
    sha256 cellar: :any_skip_relocation, monterey:       "345f5b31b7c72cb3ceb33d12684ab10db21dd797e390934e1d19f538dc04fa47"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f09975ef53e57e75779751325bdc2470f9cee82e056a96a36586fce605faf8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3d33950cd79c3cef0f6927ad2534991f8802fff3bf4ed099568dff6e8e4ab7d"
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
