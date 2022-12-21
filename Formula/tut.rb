class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/1.0.30.tar.gz"
  sha256 "404f1d6647920fc32fab02c92ee23ab4a7e2c7507d535669c4e5a29075d480b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e14ce96ee49f0fc8dd6b3e65be234eafbb635410516a2f794866b8cbead6eaee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "860cd20d0806ef4e6ab4b22b7a3ecc9ac9984fb96867dbd7d1afc6c68bc54613"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58d86185b3a24e419c1bb5e172aa3bb17cdfaa13d6c7311744f3599ab2ba8458"
    sha256 cellar: :any_skip_relocation, ventura:        "74f57c70ed954f03517982047232881ae021701e3d14839247ef4bf26ee05579"
    sha256 cellar: :any_skip_relocation, monterey:       "42261660c2c55f635bf062fd7bab6d9e78e8e446db4ed9a548e2d7947817dbc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "186c893fd3ffcdb26f580e8f71732fc4ba7b7a9ffc1e2584ae8ee92b60f9a8bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f13e9a38b9142958d3b93ef5e2ffe96c0767a856c95ffa47f7eaaaa59e0f2bdb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tut --version")
    assert_match "Instance:", pipe_output("#{bin}/tut --new-user 2> /dev/null")
  end
end
