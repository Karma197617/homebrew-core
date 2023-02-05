class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.7.5.tar.gz"
  sha256 "399bd61afde4c4bdb5dc5910479e3779df5cd1888c554b0bbd7ae3b97620780c"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b51349d9182e9e20fded92c7eeb692ff1800f9fc73ec544cef88785efc2ce812"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2de99efde1f819c49e2938f882cf677ac8c55dd9cfc3373f1e76f3c39e454e6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fff5e5bc4ac1481c49ca8fac6fd87ed93d6dbb98758ff43c3ad1e357c353e324"
    sha256 cellar: :any_skip_relocation, ventura:        "9b97ed0aa3e952c19840a5b63a1f74d057c416ed0c23cfe790d80b505d620947"
    sha256 cellar: :any_skip_relocation, monterey:       "57a08e863cacb7ccbc1a32a3f5372d3de4fd20915f0fad93925ade19fbc8eaf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad8e61da11600b4f62157cf65800325b5001f01005baf786a8069c602d42959d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb3fd605184e0943d82b3007ed97ef5dee59eefdb5c7c2842f92d55e58ba6e33"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid username or password",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
