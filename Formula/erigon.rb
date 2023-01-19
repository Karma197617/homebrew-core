class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  url "https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.35.1.tar.gz"
  sha256 "4abbe03ab1517e954e20a19d44689bcddc598b5e997c7b27ece8643d201addc3"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "977a08717dea435c7810ee4b2dc2d73c01c74fb2b13a19186d47d4f7fc01ab15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62c03a7f26416a3768319120e6190ad8af06de528ead415833e21c788e3e0ef4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ca701233fe5d880bd204658ea27a1c1a44b64e25f8c59718a95d0ac7ab49df1"
    sha256 cellar: :any_skip_relocation, ventura:        "1bdd7b7c204fb988a77017e2e3d3d9273147903411580915275c6c1fbfc70b65"
    sha256 cellar: :any_skip_relocation, monterey:       "37d203ca932e624d8037c9ff7758ef258194f2bbf2e87a7b0bbb3ec27d41562b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e053b090602ec1944aa5cdf961eeb4d81160872bb419e83db651e06060ee133a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85d44f9f413a67ce68057afe2773e6cce002b1224239436376f0acfc6620c060"
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
