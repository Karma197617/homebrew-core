class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.43.1.tar.gz"
  sha256 "4fb73145923e6fc41ece74fd3b5697a826e30b2fa4ff959b10b8f9786bb95571"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f211dfa095845bfdc5dc5dc6efb402a09a676a5edfa998fc5fbc01b4dc1fe1d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fe8d33a50c413127d7db5c6ab791d807aacf4857c80bf1f55ffd326e413c8cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "996e69f73c8b7d2c9c2f3ef508367c3c113b3edcdc9e1a3967fb8f59fe4a3ca4"
    sha256 cellar: :any_skip_relocation, ventura:        "536ec2a689c0fa9361b5bf5c015bc76444b154beb9d406ea5e8df6a75f0c053d"
    sha256 cellar: :any_skip_relocation, monterey:       "4fc96ca40d6beed358795ed2a51930f4bf23f8a6bc4042281fd8bba00b9c41ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "7118cd39b528f3ba3aee16d97c7b31842c092cfe6498a829278b38f29ece51ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a4d0aeda54f831a91d26b6bdd4f475ecd98590086da1427ef750b9552215fc4"
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
