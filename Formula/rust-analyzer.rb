class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-01-23",
       revision: "daa0138e4c159d5753e41a447201b6191437276e"
  version "2023-01-23"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fb00a527ac40137f40aa1108f77dce3b27169edb0f3490d419fbb8071158e3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59b34c1d9b74449087c4d18a52bbf375dfdb93bd5ec42a1707becef7d5ba5c4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45c56151a93d1229aaa6030d28d5458fac5b58128ffc464f47afd5f9d06a4c02"
    sha256 cellar: :any_skip_relocation, ventura:        "d454050cd8d7fc92ca25ffcf5c48167dfbdfad98392d03cdf71314c3fe61c8dd"
    sha256 cellar: :any_skip_relocation, monterey:       "2984072bbe4cfae969449b268162925c2dbadf8882b4edf80555eb1d1c51f52b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfd064a585feb6cdeb0b51b2c10a494edcbef9fe8f85e2c1602bbae09d43d0ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad62ae7345091c10db99114b7f719f20804dae58d743bb2df082b5c1fc80781b"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
