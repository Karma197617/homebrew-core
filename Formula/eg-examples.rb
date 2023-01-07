class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/5f/3f/f55eef404adae2d5429728722d6a81ad6ac50a80e9b47be046cfbe97bc44/eg-1.2.2.tar.gz"
  sha256 "8d3745eceb2a4c91507b1923193747b7ae88888e6257eb8aaccf7deae2a300a7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c998d2ecb20e008e38511d86247d6d7c5d01b8def623c77508ea62cb15870add"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c998d2ecb20e008e38511d86247d6d7c5d01b8def623c77508ea62cb15870add"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c998d2ecb20e008e38511d86247d6d7c5d01b8def623c77508ea62cb15870add"
    sha256 cellar: :any_skip_relocation, ventura:        "aa47a39ac7fa11e465914020ee475b3b9b5fbd22bbb32c9dedb515d8b0dbf8b5"
    sha256 cellar: :any_skip_relocation, monterey:       "aa47a39ac7fa11e465914020ee475b3b9b5fbd22bbb32c9dedb515d8b0dbf8b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa47a39ac7fa11e465914020ee475b3b9b5fbd22bbb32c9dedb515d8b0dbf8b5"
    sha256 cellar: :any_skip_relocation, catalina:       "aa47a39ac7fa11e465914020ee475b3b9b5fbd22bbb32c9dedb515d8b0dbf8b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aae0fe8abd670208bea20796e5854d315f26eb35a886677efe1976e5d7a00e04"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end
