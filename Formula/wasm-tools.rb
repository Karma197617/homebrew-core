class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.20.tar.gz"
  sha256 "c2303e705802037e2b375e8c21e45b558b3f0b04fdcf4b7179ed549a39951308"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaea88662c47662b7a0ed48463b560ed993eed56c207224b3ffaf236a4f5ca65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10bebd9856b2040514146830c3fdf8add283cfe0b36f125d5f7c800ad1d5d762"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "089bcdd7dc5f302cad8f9704de9d57f36643b1cfadbaf1d2ffe6d415a2ac598e"
    sha256 cellar: :any_skip_relocation, ventura:        "4a5122445b1027166fce33e253cbe9033d3f65fe4502fbf06929344d6bf22033"
    sha256 cellar: :any_skip_relocation, monterey:       "64bf7b1a07450af8afe05099b524888a17631af4581e943097fc0be7a92c969f"
    sha256 cellar: :any_skip_relocation, big_sur:        "24cb566a0f267617d1e3be7593a8fa2a14b7a4dfc2efdaf442cee03d14d526b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "973533a01ea3aa392356a6d996043b1367ccfc630b6eb9cc6db9e8e420a403aa"
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
