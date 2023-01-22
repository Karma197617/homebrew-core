class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.36.1.tar.gz"
  sha256 "7481780feb837e660baa598f3f95423887f6ce3efdbb854908fdb3509014b509"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f379bced46737fc6d5479c6e4eddd319f977ef7201fa833d417fd6f2f31bdd29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "419f05ee2055bbe05dbb220b4e839ed240987ffc17bbfe7414bbdf1fad67c6b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8530ffa48a1cbbea42728f4cd7403f71e0dc818e5e65bf183933e74410369e07"
    sha256 cellar: :any_skip_relocation, ventura:        "7bfe4e31da4167833f0e96c8f1f78f889ef340b6402b6a48a64aeb48ea34c21d"
    sha256 cellar: :any_skip_relocation, monterey:       "845ef0d3807f8483cc276bcca2660af5f4435f10a0771585b3490ade2064a041"
    sha256 cellar: :any_skip_relocation, big_sur:        "90251a2ecca646416284edd217b457ed7a792619d8963f9b70a42839febe7773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a31ae6e0cf3645cc5767b943b9ebfd99577966ebf10b76b64c73a082b532b46"
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
