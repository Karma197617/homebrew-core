class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.3.1.tar.gz"
  sha256 "da89dafd8b6185aa635346753f9ddb29af29bc4abd92dd81f37d9d6560b5d64e"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "4121657e010a147567cfb9c119719caca1997131d8bc3a1c3d64cc51749bfc21"
    sha256 cellar: :any,                 arm64_monterey: "048f6b502ba5cf242a18b858fa92f7a80be05f691131bc536741dadf4e1f9602"
    sha256 cellar: :any,                 arm64_big_sur:  "4334a3092fcac6f5c894029fd94ea42f6d5955fb23c274a6db683ba391a75057"
    sha256 cellar: :any,                 ventura:        "9342208cb9d59cefbe8997d3dfae6347ef8735d60bdec4e4dfe02afb1ec3b6e2"
    sha256 cellar: :any,                 monterey:       "805bd4bbea1cf4befe41f725073609f96e815ea143a6fd964aa9060aad2b10f6"
    sha256 cellar: :any,                 big_sur:        "aaab33462adc61ae55d3b0163dc1360ff8a084822bfb5dfbc63ab8d17de810a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f111e091d70132fe778b05e7bcca3d929cfbfcbd893eeebcb7cb5db059231a28"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@3"
  depends_on "pcsc-lite"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_C_FLAGS=-I#{Formula["pcsc-lite"].opt_include}/PCSC"
      system "make", "install"
    end
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
