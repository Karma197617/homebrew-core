class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.43.0.tar.gz"
  sha256 "9cbe305a7b4f6b3c98bc9c3d157bf26daad234f22ea92780094aa20fbc17374b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3acddfbf92653721d6490017abfedfb79c7afd996966d76dfb497e0b02cdac4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4d457f405eeacebce1f848f695f13a9aed04f9673266950ccb6d44ee3bcc650"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2d3b4e2af7f1d8b3d707a66f4d166532c1e38af14e79f22f73343e626817fc7"
    sha256 cellar: :any_skip_relocation, ventura:        "154d0caed0132d12b25eb8883772ecaf6038421d38c73120b9f4d4cb4322c5b8"
    sha256 cellar: :any_skip_relocation, monterey:       "105e6a0bc5d0f5031742266a873e4e43a4c08d0ab608f49421434cacd4653fed"
    sha256 cellar: :any_skip_relocation, big_sur:        "d76ca08864fe0069cb681aabcfa21049122d4598d4e661e2f86d0a49a42f60cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffa4f8eae9d52dc27bd7fe6065bcda42fe850c5e91b21e9f68cdf7271b2a8bfc"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
