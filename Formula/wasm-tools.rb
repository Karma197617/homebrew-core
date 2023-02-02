class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.21.tar.gz"
  sha256 "156343ddbae13c177a83deeccd2de1a97bdac150e7f5c755e009b62ddd86ba15"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21ddc5dac7c0686445560d66cc44dc62e7529e361e137384d78b6ac5ab948832"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3d2ca5514997db754446c0b9904ddb3bd48d12feebfc90a2a7e42b100bb194b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49216211bfdbb78ddea8ad4b9740ed1bfa0129a24117d3a42ba3c4291b9acd1f"
    sha256 cellar: :any_skip_relocation, ventura:        "4faa9f8aa5995238420fff5c59d2c1529ae0061cb112f07e41165ded81334d2f"
    sha256 cellar: :any_skip_relocation, monterey:       "cbbec21a7d40f5850a9a07ac93f6a2c251f2cecb556fbca2cb212c555746f999"
    sha256 cellar: :any_skip_relocation, big_sur:        "17aaaaeab1e578dd64749dce65c02cbb9cbcc19a41ef66504f0feb276435464a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbcf4f929ab7c044d590e96b10a826c45f3e7f77d70443b7322a93201cbe0df5"
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
