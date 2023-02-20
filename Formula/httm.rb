class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.22.1.tar.gz"
  sha256 "50974204cd00b5800dada61a47abddcffdedd59a4828c7df29d77a51339c8f00"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a9ddaf10441006fc0afc3fdf350273210b907ff6a08e2948ed49faca59f3adb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9034522f0f309606bd3b1395c5482ebe79086ebf128a4a231c9062ce98e9fa9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abe211f83261abef51e4829e6baeb93e995435b0a9099fc2d8dd2e0329c52329"
    sha256 cellar: :any_skip_relocation, ventura:        "c4e6e542d4c5f1582de04eb8f919c300e55d4850a9da996857396418d4dcd069"
    sha256 cellar: :any_skip_relocation, monterey:       "fa021bae3f61181125f6e875adb2c5ee503f138d4ace214c61bce2f681801793"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc041458970a68dde84fd945a3bcc53252ee266adac09546a5a57a0fc62a9aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb36e2f270b1cfbe924dea0f8860df8c0f9d165c260776b33eb93cd94a4ade52"
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
