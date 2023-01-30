class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https://ipfs.tech/"
  url "https://github.com/ipfs/kubo.git",
      tag:      "v0.18.1",
      revision: "675f8bddc18baf473f728af5ea8701cb79f97854"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https://github.com/ipfs/kubo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c069b92df176ab50e5144a6d10821600601b16713f3f8ad84b92a13e6dfdacdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "592ed859d6b4e63a987ea1e72bd71c78f0117bfbfec9d867d1c285791292fe04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85076d271a62ab339c76d4e934f3ea5a849a48fbf1881611365f6096e9679fdb"
    sha256 cellar: :any_skip_relocation, ventura:        "d3b1d389e50b7c48a69b30bd752526d448eb72f5ffc0c7afcdcf1781fec497f4"
    sha256 cellar: :any_skip_relocation, monterey:       "141bf3b6a12f41d114a82fb581f7908be7df99e7fcfd13269e36517c8c796793"
    sha256 cellar: :any_skip_relocation, big_sur:        "68f48c3df78438675dc5acbc614adf7ca7d76a27204db1ca011580c98ec7bf9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5494a379c181f1e392f5f9807be198053a8fb13152afd133c0adfbcf9c5d73b"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmd/ipfs/ipfs"

    generate_completions_from_executable(bin/"ipfs", "commands", "completion", shells: [:bash])
  end

  service do
    run [opt_bin/"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin/"ipfs init")
  end
end
