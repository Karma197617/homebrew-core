class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.98.0.tar.gz"
  sha256 "80308a614508814ac70eb2ae1ed2c4344dcf6076fa60afc7734d6b1a79e62b16"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48281dc438f7aeee17da2fc19f2ebebbd4fd5ee090cd6ffb6f9d4c60551e802b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b16732790025d8358e39d8a3d15226892fb11c5d11d09c07b89930dab084e07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9b6a948840bdc6cfcdf061ec885c7f286e5a3e2b2f99cc739e6a60eb7c5b67d"
    sha256 cellar: :any_skip_relocation, ventura:        "69cb98e2f67c2305809d4d3ed3ebcbdfbf9085d7f9f1dfc5a7f4f863e5a04c9f"
    sha256 cellar: :any_skip_relocation, monterey:       "a6e4465a241f8d4a2c9b05a413d1719d100c77aacb2ed55cb42e2baffe258c93"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc47b6170550634d0c4cc5e8fbafda89953b7008c436d9e1f3579fbf40be6b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "677c0a688b9ed6bbea88b955860ce80e3da483ac3df535f928e38722cbccacbd"
  end

  keg_only :provided_by_macos

  on_linux do
    depends_on "libtirpc"
  end

  def install
    if OS.mac?
      ENV["LSOF_INCLUDE"] = MacOS.sdk_path/"usr/include"

      # Source hardcodes full header paths at /usr/include
      inreplace %w[
        dialects/darwin/kmem/dlsof.h
        dialects/darwin/kmem/machine.h
        dialects/darwin/libproc/machine.h
      ], "/usr/include", MacOS.sdk_path/"usr/include"
    else
      ENV["LSOF_INCLUDE"] = HOMEBREW_PREFIX/"include"
    end

    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    mv "00README", "README"
    system "./Configure", "-n", OS.kernel_name.downcase

    system "make"
    bin.install "lsof"
    man8.install "Lsof.8"
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end
