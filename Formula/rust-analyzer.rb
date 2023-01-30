class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-01-30",
       revision: "f1b257f4eb4fef74b42fd7135d1cf3884e8b51c9"
  version "2023-01-30"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d4ec1604c45dd11a665d84ed4c165b9c7e502b788d84c549d0e9fa13f6c2e34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d39cc64da5d39d35c6fe244c42df99f1501dd0cb34ff9519de6a0e9a485be818"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0fe86b72ade86e8efd3e9e78f59e772e1c0fc9c7f095d269300ab54552d6030"
    sha256 cellar: :any_skip_relocation, ventura:        "72c3c3235ef8a9fffa15784a720a859a7684d342d009381db30036d80fa215d5"
    sha256 cellar: :any_skip_relocation, monterey:       "4f3f3d4be03c14efc6c6c72f1b723b05b37993c2f5e0e9fcf22a5f19cb92066b"
    sha256 cellar: :any_skip_relocation, big_sur:        "37a775d1d8c7dca30129184248548a7844e280463fc022b838fbfd2c08966ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "746b1be95a535ab04443e788cdf1c32a0b396c64f88ecc34d67543917166e96b"
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
