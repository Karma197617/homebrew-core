class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.19.9.tar.gz"
  sha256 "4371f155f940aa1b04a5fc3b6c45cf99a7bc6881a0998168355bd9fcf191f0a8"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a97ff86625075a7128f0b1ca54edeaa215be5f6bae781953bff67894f167e89e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "995fa225aa95ba33d8280c6751ac2bdb4d535c6237d4efdaac1b491b62b7522f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78296c298822e3cdd65e94680c2458eea2716f68caf677b771954beb1b963197"
    sha256 cellar: :any_skip_relocation, ventura:        "3c714432275ed17d6315572d628a52c9617f82b5cfc8f1a7a8341fa3de490768"
    sha256 cellar: :any_skip_relocation, monterey:       "2c4513a2c3560443030a743efe2f1e256b636f7c4931f03e3d732f2c1a3676b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "571fac12cac9c376275a16edc1825748d7943d328f347445a2f381cb265e9d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b88f9b94bfa572e29bbcc8acad3f80fbbb800afb7a3b8d9dac6fb12e4aaa1c13"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
