class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/6.15.2.tar.gz"
  sha256 "39bb722b195044f6bc9079a394b82841c4bf19c106572fcca3945cd632f92fb5"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "897a7f20c2008e2ac4f8300076f355a6a4e0a7579ed38d4de4d8c50647874cf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c483562fdb65df7000eb510ff6705668201da5b3398842888225c18bfcbf070c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4758dae427ce361991c21f3d4e1d74082f0b51fb26d6d7c4b2df12145af17829"
    sha256 cellar: :any_skip_relocation, ventura:        "4a98b3bc5be1717cd84079bac7ce58bf93415cbe3fa0d83b86612d0d8d357914"
    sha256 cellar: :any_skip_relocation, monterey:       "6f1dee8549b624c63ebe5cd7da15df8c51eef8696b432293d6c67ce7be75d64d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce9a50feff4fb04f5efe467979a545fe0b9e9ae277594c357d2a0413f540c73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75d8fa691cdb47e40ddf82507ab8adf70458faa05928d99c14ad2ca0335fba02"
  end

  depends_on "openjdk" => :test
  depends_on "python@3.11"

  resource "homebrew-testdata" do
    url "https://github.com/oracle/graal/archive/refs/tags/vm-22.3.0.tar.gz"
    sha256 "410a003b8bab17af86fbc072d549e02e795b862a8396d08af9794febee17bad4"
  end

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{Formula["python@3.11"].opt_libexec}/bin/python"
    bash_completion.install libexec/"bash_completion/mx" => "mx"
  end

  def post_install
    # Run a simple `mx` command to create required empty directories inside libexec
    Dir.mktmpdir do |tmpdir|
      system bin/"mx", "--user-home", tmpdir, "version"
    end
  end

  test do
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["MX_ALT_OUTPUT_ROOT"] = testpath

    testpath.install resource("homebrew-testdata")
    cd "vm" do
      output = shell_output("#{bin}/mx suites")
      assert_match "distributions:", output
    end
  end
end
