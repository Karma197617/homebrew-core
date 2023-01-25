class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.8.tar.gz"
  version "0.29.0.gfm.8"
  sha256 "94a145b7bc18cd4e85edce0a65ac71f24cbafe8e4402c3213835517408a10118"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "96c75c34a0dad33ca7fa3a94a26aeee0ab0a36388a0550f334a84048afcb67f4"
    sha256 cellar: :any,                 arm64_monterey: "5d6ea7956ec7ef8950149ec64bfc129a0dcb0f41eedfe465c08e92db86e9d9eb"
    sha256 cellar: :any,                 arm64_big_sur:  "e2ff15695a643fe2566f65a882de693127644bcdf7531249bdf6bab5ce41d70f"
    sha256 cellar: :any,                 ventura:        "ba65f94c3f654c3d2362d32c948b485e09a40e7652710135b426dd0bfe0d6fb5"
    sha256 cellar: :any,                 monterey:       "022325b6bae2199a6a15a87b58b0241cdbd05c8aa54c96dd3401a7775f6d8a19"
    sha256 cellar: :any,                 big_sur:        "225d3ac23fd13e580bba9c2d6581d17a22c43d9048e286094344d975ecb5e800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccbd8fbbc5e93b984e06ad4598ac45c7c843933a3e8ffbe304efe196c8f5d0fb"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
