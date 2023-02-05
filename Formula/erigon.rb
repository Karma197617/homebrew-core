class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "0756b07058230beac11b134032203f6698fa97c4038cd6fa12e49fcc10e60fd2"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "145f95f95c469d9f6eff4b7b1d0c5945673847efa2d2ff94b816ef52e93187ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "367858b3ae38a6b682235ffe61a6989491054b8bff8fcffb3686a640c2cae373"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6ff7eb388b66a2b4d30fc6e11bf2d8de43c3189d9aa903fe03b758e42a41fa4"
    sha256 cellar: :any_skip_relocation, ventura:        "1ced6b8a0de2955b3ca06bea084b1a6285c98f8c85767b24ca1390b6b8a97107"
    sha256 cellar: :any_skip_relocation, monterey:       "c2401d2b1b146de590923d44b59915eb60b811e731a67dac5b2f4f05d0832c57"
    sha256 cellar: :any_skip_relocation, big_sur:        "a66e2b988a73d07f0974919c19dd8747968bb05af7557be1725c3896fc3e0a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4401833f46d2ec3f94bf92224e541b9517de43fb8c95b70f4ed0255c09492bc"
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
