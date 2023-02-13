class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.21.2.tar.gz"
  sha256 "8bd96e5e41d379d06d0f2e0d85e895bbdc5ae2e22362d3750a6ec6d8643bdeea"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4164a4eb7eeaa3676f1ba8982a4e4e79c72991375a1cd2f464ad7ce6589cf17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e786af28eae566e3b4705f39bc6765338f17c2e28c519a6b430c0aab2ef96c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e710d64110ad0f4d3e1eb95c2063e70c139eb470091f4d8d35a03d726ada4038"
    sha256 cellar: :any_skip_relocation, ventura:        "59455eca6819e437b1d0e9b73f0f97ffa6d2ad9b7b6cfc6ff2ca2833ac403b58"
    sha256 cellar: :any_skip_relocation, monterey:       "6e37aeb3b5a7cdae13b1ab8abf25c5863bc475a856e9689aaa90974ee170daf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1f6632b8d28e9c4c212d577a22176cd65340f5f04f0b8f4183bb0f6e196303a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "506bac0424d2c4dc7be8349a75b1de304c65c36163dcaa527e2ef79b88ba3882"
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
