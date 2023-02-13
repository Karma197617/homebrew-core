class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-02-13",
       revision: "646f97385709fab31db2f10661125c0bbbda6b7c"
  version "2023-02-13"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19e88474fd0be888c23d69a8537a560611ed5c49b858f13a37db8eb8b5eced88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8952187f88045be07601265463e4c9b0b029d1a299371caddf71bb4bc8a38d8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f99a24bd5bd97abc2c954e506861ccfc56277dc654cf0201075101658ad1ad1f"
    sha256 cellar: :any_skip_relocation, ventura:        "e75d90f41a68003a16cb777f7543a774ee73df10ea6fb663e65c0aba294a9fc5"
    sha256 cellar: :any_skip_relocation, monterey:       "5614208a56fe8b96491b34887bd0d44d3682060176515db13824cd51b39bc8ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "867eb1f5c803b816b55154207f55ed09d51ca683027f46093032338c2c645310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fcf22ceeac8d2e48d95cece2696a4a2ce7e26f30bdd626d3967eaed09ac3ed5"
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
