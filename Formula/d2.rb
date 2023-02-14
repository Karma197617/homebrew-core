class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "15434cf2776b7e61da1b8142a221e2bc675881a53f864ecbe152f527903caf75"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec18810ebcb64ed3cd50bed1f315cc2932ad95602befedd9c7117a376e9e3689"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "742a2c9ef67093755c0955733ffac25760bb0e4f768248913b16af1b4dda6ada"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d83dac1b81654478a6844cafcc920f6e5d454bf7550978e4fffeab3d69d0eb5"
    sha256 cellar: :any_skip_relocation, ventura:        "dfe7908dcb2ec09b6b52a6b600ef5fd202920dc6466a5ff8192eb44f30f32ae5"
    sha256 cellar: :any_skip_relocation, monterey:       "4230bfe06db6d7b491d7cf3728985ff274c85a5fb2460fb1dae5ce70dc197340"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c94281140a07621f54255ae2e8f9b697e1958d4d4081587cfd67a7655aeeda1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "299d9e1702b976d146ddcdd3d243441cd0208fe0d3d5e2f328ae16f953bc805f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", test_file
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
