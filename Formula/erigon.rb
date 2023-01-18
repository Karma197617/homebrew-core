class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "96406fc4886b27920112432a256eaba6571636d71b8327523f75e1211dea37d4"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76c234c2ca0b8559f3157180c1a30f183cfb8610c8909eb7678991f5e3b9734c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2b7da215717fc3826fb3bf41ab3b5b3f4a714c5149aa48471c2a2547b17af37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4952dd096f96fe4989ac9c80468a6731dffb034ec939a68feb2fc76b9bbc133"
    sha256 cellar: :any_skip_relocation, ventura:        "a9904012338979447d2698e4ba19d5f0aeac6ad1abbb3eee9b2531f58f29648a"
    sha256 cellar: :any_skip_relocation, monterey:       "43be8ecd16957ccb9829633866b5622faec79bf1139161536a60018090cb7872"
    sha256 cellar: :any_skip_relocation, big_sur:        "5229e685a0334be9ee652a160c8927357c95b723536e4900df1e60d1d89a524a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49b522c27da4bd8b1d75907e6097214a9b2f113016a4e6c2f752b2201a821b6e"
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
