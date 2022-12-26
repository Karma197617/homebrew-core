class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  stable do
    url "https://github.com/xiph/rav1e/archive/v0.6.2.tar.gz"
    sha256 "8fe8d80bc80a05ee33113c0ee19779d9c57189e5434c8e1da8f67832461aa089"

    # keep the version in sync
    resource "Cargo.lock" do
      url "https://github.com/xiph/rav1e/releases/download/v0.6.2/Cargo.lock"
      sha256 "5f1f34a269322b8ec6c6432d6b928c72da254e16e65a0c8f81fe252367a99ba5"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "781fdba55f672f2808d5a942645de9fe9e032f9c6f4b74a626a1eed77d8d5238"
    sha256 cellar: :any,                 arm64_monterey: "cf02db9e7de5fde855205de5c4712ea332a6165b155063bca322bfc292704b2d"
    sha256 cellar: :any,                 arm64_big_sur:  "2a18dfad1d04729a15103f084449a1fa1378e571651ec96d145d59158abb1e45"
    sha256 cellar: :any,                 ventura:        "a162a9c35f1adb24986a47c654250eee20a5adad72b473c44cf7f3adee821a5e"
    sha256 cellar: :any,                 monterey:       "c26df3fe0341c72aba9ce445350e6f73bc1e4c1e730a7ada7d6e4b03d7b6a2ac"
    sha256 cellar: :any,                 big_sur:        "6ed0c0c4c1c8dc2e3da2caec1c70e9866c372813deb1532b4ebc511fbbd5d13c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6298430329a5c5cfdb1d170b2690834a4759aa14515a3a0fac8aa91204b9835f"
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
