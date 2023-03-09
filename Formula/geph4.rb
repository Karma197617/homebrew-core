class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.7.10.tar.gz"
  sha256 "9be746e50a3525867cf4917490d86d68f6b118fcafcac7ec134a094b50923488"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1c8b4f6d966b5fdc276fbffeb3d9eec0013cdae98ad4977f8b245e60a82209d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bede02f609b942ae73f57180e14d0d1bf187c2ef14ca13d131b9ae36e8e1842d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9950652d15c680da398f4ced2eb4ffdacc156f52edf4577d210641c5c4865b90"
    sha256 cellar: :any_skip_relocation, ventura:        "88adbbcf87866238f601b0bf248b7d5917ee1a92aad2abe200ec0d8dc9d6b0ca"
    sha256 cellar: :any_skip_relocation, monterey:       "494f957da90931ca0d6ec894faf4e3cc589a0ac0350183157425a5ccef185c72"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d287967d840f7951e50303f60d523701fed52fb8eefe04777a4760a536e850c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9255ec3300eba010ea33c52e46fef40abccf47a7ee38baea482d26d754abe0e3"
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
