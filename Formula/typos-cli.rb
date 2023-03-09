class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.20.tar.gz"
  sha256 "bbaefc5a03bf16503e700d90466efed858102c858ded87b5c49c1a76b9b7d65b"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b36b378dea9405b0367efc7b6b39ebb0e5e882b69f9f106087edc3e95ccd60fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caec5219c972472150feb19218e507b73f4ab5fdd9fc9a410e0a1e557692b84c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e67fa13a9bee1263e834532d19c54376bf27e84d125a7a3ffa1de250bd7ca7fe"
    sha256 cellar: :any_skip_relocation, ventura:        "d8d43bdb39da308d1884efc9a945157c006a85045e19efcf6abe0df96403b866"
    sha256 cellar: :any_skip_relocation, monterey:       "a6d5aef96913b189c203e875a288af4253fe26ad3c3398134f700963f524784a"
    sha256 cellar: :any_skip_relocation, big_sur:        "942571ad6c96a2342e9a075a3204221dad36fd6e1c9c5ee827785bc57a7ff221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afebfdffb8546d6f73bcfd270183b8a86d4b8f088369a970089ad73ce92cd20a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
