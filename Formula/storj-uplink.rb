class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.71.2.tar.gz"
  sha256 "74e70f180c258f58c9e048d24e4e6a2ac4d71240d342d942ee6255cfe2827418"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81d4c8522acaf2574199c70317478096d57569cb1d0ed99098325f6d4e665899"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7257a72a3d73d59f9896451d5281d0466266236955b995cd7e8c87ed49907f5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "103987cc1680d6bf8d83e2cf87292ccaea3dc157d441075afdc896a9dd2dbbbc"
    sha256 cellar: :any_skip_relocation, ventura:        "aa4b9f35b5f8d280c57800191101e751742dbff083c73e5a4595a778e60f1daa"
    sha256 cellar: :any_skip_relocation, monterey:       "d12111d6315b0194d7d6e596e59fc9a15392829ad2752c36cfc063b89f0e35b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e162677ed95f2a6ceb15f24be77315ae42f81e62153f8d57777a77fee4316bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b18bf813cc55f3445111cd525517af0d9cd2bcbe2bcd18b96c11c7da6f791150"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
