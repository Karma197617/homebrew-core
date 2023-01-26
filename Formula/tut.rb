class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/2.0.1.tar.gz"
  sha256 "afa8c49036461a36c091d83ef51f9a3bbd938ee78f817c6467175699a989b863"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0761e617d35d4a8b91a46df2321d35213c77721d0ff95fa65bffbce6e451942"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "794d8b4d5d23f9f8123d4b5bed51e645ce215712bcdaff691968ad1d97c3385d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd035bb07cd424d869e63b2a4c93741d441475d59a7eb3f525dfdd36dc13dc35"
    sha256 cellar: :any_skip_relocation, ventura:        "46bcf1ffa747088b679a35791a2ac3667f6cd2d8741c16a3b814438c79ad1658"
    sha256 cellar: :any_skip_relocation, monterey:       "5e705ff6e0c9bfd6f3a5a9c79976a167b364854018b5a6c3aa9f0c8898ca12e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "46b6e873f2ab5da4c67812c15a3b8ba5779df9b1c9ae488ce79cd4add929ed5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6398f4c77bd4d6b2317e83eedc3716f345fd1c7d37c78da745d4319bd051afa6"
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
