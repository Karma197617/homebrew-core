class Dutree < Formula
  desc "Tool to analyze file system usage written in Rust"
  homepage "https://github.com/nachoparker/dutree"
  url "https://github.com/nachoparker/dutree/archive/refs/tags/v0.2.15.tar.gz"
  sha256 "436484f7335939c208860c7e062dea47807aa82f175acde684d8f13f6e7d0efe"
  license "GPL-3.0-only"
  head "https://github.com/nachoparker/dutree.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"brewtest"
    assert_match "brewtest", shell_output("#{bin}/dutree --usage #{testpath}")

    assert_match "dutree version v#{version}", shell_output("#{bin}/dutree --version")
  end
end
