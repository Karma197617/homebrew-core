class Rp < Formula
  desc "Tool to find ROP sequences in PE/Elf/Mach-O x86/x64 binaries"
  homepage "https://github.com/0vercl0k/rp"
  url "https://github.com/0vercl0k/rp/archive/refs/tags/v2.1.tar.gz"
  sha256 "0c02ce21f546145fc2bcc4647818fd411c8f55ed8232e28efdee8dc04f150074"
  license "MIT"
  head "https://github.com/0vercl0k/rp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcbf9fb210132a603c35746444b28de6ca8953ffb3002bbdf7eaefa10c871bd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2cc474474f5fe70e41d693e534d8223e60085ab01e905125fc845d6605101b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbbff042d70c19351c17402b84281119ca54b0e891e6ac51fbc860bd2420a60d"
    sha256 cellar: :any_skip_relocation, ventura:        "5cde470fa93797c2c98228c941ae9821b104054f00aaf4437903c52bfedfffcf"
    sha256 cellar: :any_skip_relocation, monterey:       "b150d2d183c7630055d6ca16e1b8c262d280bc033977b2f78e34200ab814e7a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3317f6ee6566143a696822292eb36e606ac36c477f38b144091506a2aa917081"
    sha256 cellar: :any_skip_relocation, catalina:       "b8377b907ca950b7cbade53319faf087cd3afbd6a392d0d706cad3fad4699a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67081b03c03ff06219bfc8eb32c5ac87c5dde0c45d183eb974d14956f0f32e88"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    os = OS.mac? ? "osx" : "lin"
    bin.install "build/rp-#{os}"
  end

  test do
    os = OS.mac? ? "osx" : "lin"
    rp = bin/"rp-#{os}"
    output = shell_output("#{rp} --file #{rp} --rop=1 --unique")
    assert_match "FileFormat: #{OS.mac? ? "Mach-o" : "Elf"}", output
    assert_match(/\d+ unique gadgets found/, output)
  end
end
