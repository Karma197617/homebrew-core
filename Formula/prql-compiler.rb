class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.5.0.tar.gz"
  sha256 "c44408c2321a5da0491598eb11e0e1c16ac38cef846c28a50626897d9fbdf70f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2a695e2624be7ee5ec0b80f0c3ba88dc2fb6946c8f83445970e2cbc8c0ed554"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06b68acd7cbea06cc5203bdd7fc4b98a3f145e280ec0792e2281a011a26e302d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d3abe52ade748cd5a2dce53d78f978934a7b076f89ed32f68ad14648af2f10e"
    sha256 cellar: :any_skip_relocation, ventura:        "ae9767ee0532b1530edef4789523a5c7b6915ebf95f3886952f9959934046418"
    sha256 cellar: :any_skip_relocation, monterey:       "cba08820485652214e0732cf2d7ad615cdd3d5778a1c0b6e33d77ec8603551f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "904e9dbd65f115a71700b6b76a2593b1ba8c1d3df52381841f17915cc3302640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c9eb722cb34436c60f012e55b6680ff36a19098c1f94f019ad497517a45053e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prql-compiler/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
