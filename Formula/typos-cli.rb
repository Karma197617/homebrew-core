class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.26.tar.gz"
  sha256 "3f05d7dc3af670f2fdc28f054c1d1313b81ad040134c10f9a57492b9dedc5314"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82f054ab4d72e80443088ed764c8b47c148c85c34430b916de80943f88e587f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a75e52f0396e6748b26178df238a5e71ae50c04ee1238ea464c840c182e93543"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ca939be9e6c5c175f315c59cef3e1a0883d5d7fd90813158b43e82c4be3963b"
    sha256 cellar: :any_skip_relocation, ventura:        "14bff97988e09e0e892149dda1516d686a97c183509e14df0c5b83b696501d1b"
    sha256 cellar: :any_skip_relocation, monterey:       "e137c073378fa0221fcde348ed3d37337a4a16fb87d0e4c5733dec8784793aeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f69b4e0af14a6893a65d5e65996523693df4cd8c88a0317417349e6b0f81177a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65a31e39c9892dc1c5166aedff74f0edcc396acfcee1e362a538d0eb0762f47c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
