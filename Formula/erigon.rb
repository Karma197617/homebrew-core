class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "2d2748a5bff46caccaf70ad19f7382146435c7b53c22c6f28e4c1f1e474c8462"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6442ae7b08c05ffc0e67412fb5d950988086ecaff9348cb06a5622332313229a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81cc3af728d8e52b685c1c9a908c547635d31f9e809b9c9374a76bb975089749"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d26175ac46ede78cae8ef5f41c6ad12d8ed0a892a36e86f6524c41ce1a9ac72"
    sha256 cellar: :any_skip_relocation, ventura:        "529d157d5a06627d5408c49d684b21025ddd8f404a75cbffa08d72a6aeb1447c"
    sha256 cellar: :any_skip_relocation, monterey:       "680d298dce4a8264deff34dedac00aeddbb9b9a6f4d1c46a7884e012ea1d3c9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "25a2720c7a7d4a3c7c31fe4ddabd4ccac5e94a280efb3ab3fee6943704448fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b6bedad13ba1260a49da03e8489ac2f9fac55472c58000bb64c1c9692956e3"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build
  depends_on "make" => :build

  def install
    unless build.head?
      ENV["GIT_COMMIT"] = "unknown"
      ENV["GIT_BRANCH"] = "release"
      ENV["GIT_TAG"] = "v#{version}"
    end

    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~EOS
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    EOS
    args = %W[
      --datadir testchain
      --log.dir.verbosity debug
      --log.dir.path #{testpath}
    ]
    system "#{bin}/erigon", *args, "init", "genesis.json"
    assert_predicate testpath/"debug-user.log", :exist?
  end
end
