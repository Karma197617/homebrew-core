class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  stable do
    url "https://github.com/xiph/rav1e/archive/v0.6.3.tar.gz"
    sha256 "660a243dd9ee3104c0844a7af819b406193a7726614a032324557f81bb2bebaa"

    # keep the version in sync
    resource "Cargo.lock" do
      url "https://github.com/xiph/rav1e/releases/download/v0.6.3/Cargo.lock"
      sha256 "f22049598eb6f9948b4d852850eeb48c1236a7a068692db85cbfe72b94498581"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b5b1726d8ecf856dcde35e86ea1c20cd7c939472a43043a7210e5a5c21b34241"
    sha256 cellar: :any,                 arm64_monterey: "a23010337ff70bc45e14acb95ba75852bc41d53f782e4c44214af53ee993fb33"
    sha256 cellar: :any,                 arm64_big_sur:  "c258c744d8328bfaa0ecb2cccb4402f4edc01068d511ce30f966c215e03fc69e"
    sha256 cellar: :any,                 ventura:        "d4a0f84349768b4b5e59964b45667d86130131066c4f5065ee975d1a09cebc8c"
    sha256 cellar: :any,                 monterey:       "d73eab7e675cc5e66c6848fd5bce15c86e72bc1f4b9ccbd2fb59722b186b30d3"
    sha256 cellar: :any,                 big_sur:        "285df3feec091df6671e9d97b1128c657c65b2eb03d27507c9195372303a6fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e599778a54e84996d31d2123da123582f7770f88f5ccba9322fb2171c10499c"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  resource "homebrew-bus_qcif_7.5fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_7.5fps.y4m"
    sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
  end

  def install
    buildpath.install resource("Cargo.lock") if build.stable?
    system "cargo", "install", *std_cargo_args
    system "cargo", "cinstall", "--prefix", prefix
  end

  test do
    resource("homebrew-bus_qcif_7.5fps.y4m").stage do
      system "#{bin}/rav1e", "--tile-rows=2",
                                   "bus_qcif_7.5fps.y4m",
                                   "--output=bus_qcif_15fps.ivf"
    end
  end
end
