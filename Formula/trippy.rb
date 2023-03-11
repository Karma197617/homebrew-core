class Trippy < Formula
  desc "Network diagnostic tool, inspired by mtr"
  homepage "https://trippy.cli.rs/"
  url "https://github.com/fujiapple852/trippy/archive/refs/tags/0.6.0.tar.gz"
  sha256 "4da57c19f4b6a6f3b4426ea066278ad0b0df2d2addae548b839a17fb20c464ae"
  license "Apache-2.0"
  head "https://github.com/fujiapple852/trippy.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # https://github.com/fujiapple852/trippy#privileges
    expected = if OS.mac?
      "root user required to use raw sockets"
    else
      "capability CAP_NET_RAW is required"
    end

    output = shell_output("#{bin}/trip brew.sh 2>&1", 255)
    assert_match expected, output

    assert_match "trippy #{version}", shell_output("#{bin}/trip --version")
  end
end
