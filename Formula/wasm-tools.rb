class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.23.tar.gz"
  sha256 "e2e3b0a7a5cea59ce0cc41ddcd06e941e0e3b7bae7de24543ae9f0cea40f9d44"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75401a572bed679a3f6d44bb8edb510f1e09dd2532122c0ac5d6238bb32ffd96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d7012936a4c939ffe1f1e60d8a59887acd1de69401b863876224edb33fb2947"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40c017cfa0649af219869cb0b16df6de4c62b1c5f3feb37cdf07a3edc202bf1e"
    sha256 cellar: :any_skip_relocation, ventura:        "fa59ae3ebc647ad99522aa7f03415a5f42f82d29d5f8aabfe831ad22f27110e3"
    sha256 cellar: :any_skip_relocation, monterey:       "efd1b40df45974c6f96c5174966c31c9dd9fbc44766c51125780677db08cd55d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd4c756c5445b1fe01513cf439a8cf1208e8f8290e10f7ba81210dfc81df2de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3848d01e92d12f36553cc7d89b6bb7792d29a0741ebd4907ecd586a5b3516177"
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
