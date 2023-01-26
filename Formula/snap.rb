class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.58.2/snapd_2.58.2.vendor.tar.xz"
  version "2.58.2"
  sha256 "9f73b85f41fa3e842e916c5dd46c4c4f17caf6062964cc24974ee29590a09dce"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d71fcbc59da1611f9ed68e5f9d13ab1835098a1ef381214cc583548a34a1ce19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70c3dcb234409e854c6a40e81866990326ceef7a60317dcd03aa9d2dfa3e9c63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85f4d2e4381a7cfd039c1b299edf1ea4e0f282c8f85509a6a41eb5fad652a9f2"
    sha256 cellar: :any_skip_relocation, ventura:        "21af0a58e7336dfff865dbe66f61013172f2f976043642387a24b45465f20cf6"
    sha256 cellar: :any_skip_relocation, monterey:       "7983c9e72a4b2e85978bbd1de377a1f5fc944951de8e917756269d68baf00cd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b8bc6079fda9fdd8dc9656a187535941f047cc2bb320454756e19a455837e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f006832ac06da764d57b5ff4c5342b5b8a161dcd518a2331187f8f77a5ec2c90"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version
    tags = OS.mac? ? ["-tags=nosecboot"] : []
    system "go", "build", *std_go_args(ldflags: "-s -w"), *tags, "./cmd/snap"

    bash_completion.install "data/completion/bash/snap"
    zsh_completion.install "data/completion/zsh/_snap"

    (man8/"snap.8").write Utils.safe_popen_read(bin/"snap", "help", "--man")
  end

  test do
    (testpath/"pkg/meta").mkpath
    (testpath/"pkg/meta/snap.yaml").write <<~EOS
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    EOS
    system bin/"snap", "pack", "pkg"
    system bin/"snap", "version"
  end
end
