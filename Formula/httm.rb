class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.20.5.tar.gz"
  sha256 "ab5f4140bd152124d725e0569ef25b630b2560e87b00eb45793c504b5c7795fa"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ade5460bbcdc718bcc9cecca3108acf95c7c6f347d5c31c995e4e825762ff9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a24efb95d88833e60147ae6a67ca67da504e0bed7ef72332ba4fb5387e1e415d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5fbfb42f10bfaa9dd9c05f23d5a8f03ff0fe611a8ad78d009095faec82e59c7"
    sha256 cellar: :any_skip_relocation, ventura:        "efbb314296fa36a2fad20e0ed59451e4bddec215c7e4bba1ec2dc0409dc60a3c"
    sha256 cellar: :any_skip_relocation, monterey:       "8cb9d1fa3191f173e18bed5a501cafafc66201ab6f7bb0edb921c11cf8b4c8cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e62aeda82027f6eae7fec59e4223dbbe92c4189da8aca8a1e6e0ff5d770350d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8895d3a96e031639caae9cbb3506da5f47de5a83d39508e5d1acc2acf88038ac"
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
