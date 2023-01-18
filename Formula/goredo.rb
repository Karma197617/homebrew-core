class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.30.0.tar.zst"
  sha256 "825b20daaf2315de33e82b8ace567769f271fd2ec0c3a2c2c45012fee1cb9548"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b89e7fc27ef8d0329468ad818882f32a98a6b68ade99f5dc1af18d1642a99a44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b89e7fc27ef8d0329468ad818882f32a98a6b68ade99f5dc1af18d1642a99a44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b89e7fc27ef8d0329468ad818882f32a98a6b68ade99f5dc1af18d1642a99a44"
    sha256 cellar: :any_skip_relocation, ventura:        "6e059679db1eb2ff20d31d6dce59e4c335822d245325cecd33d2fd37798a41c9"
    sha256 cellar: :any_skip_relocation, monterey:       "6e059679db1eb2ff20d31d6dce59e4c335822d245325cecd33d2fd37798a41c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e059679db1eb2ff20d31d6dce59e4c335822d245325cecd33d2fd37798a41c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "602d79668dcde980ce1c57112b15abff7405dce2061c781d47727ba0c8007a7c"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args, "-mod=vendor"
    end

    ENV.prepend_path "PATH", bin
    cd bin do
      system "goredo", "-symlinks"
    end
  end

  test do
    (testpath/"gore.do").write <<~EOS
      echo YOU ARE LIKELY TO BE EATEN BY A GRUE >&2
    EOS
    assert_equal "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")
  end
end
