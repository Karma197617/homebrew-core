class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v7.0.1.tar.gz"
  sha256 "edee6887fa99b499ee464c3809a6ea6931e68ab3791d530b57e959d7b7472d85"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d94549c8e5936f54d874f9d9bf4e8542eddee79cfe9bc74fbc9aef09949be551"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fd74b84ba9a8f619daf3e3b859111669382b909f7bbe6a60113a8ae109bdfd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "156a855a8360bd887a101ff3291ecd084e70a43153e3c8015d44cd635f0297fa"
    sha256 cellar: :any_skip_relocation, ventura:        "de4fd2bdc20adff904481a55681fecf9ea3cbf1ae04e35b9136a79ae73ac2c0e"
    sha256 cellar: :any_skip_relocation, monterey:       "7af83271d42c854d0ca06e73049c8ebd2e7b67169df3423681a30fd7576bc6be"
    sha256 cellar: :any_skip_relocation, big_sur:        "237451141d46d3a526884e29d53cb2d9d051719099afa740e1bb714dcf9354b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84334a182931c3ad2b7688e108948f83b9dc7a5df657aa3ef1c22a7b5e1ce060"
  end

  depends_on "go" => :build

  def install
    # Remove this line because we don't have a certificate to code sign with
    inreplace "Makefile",
      "codesign --options runtime --timestamp --sign \"$(CERT_ID)\" $@", ""
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "aws-vault-#{os}-#{arch}", "VERSION=#{version}-#{tap.user}"
    system "make", "install", "INSTALL_DIR=#{bin}", "VERSION=#{version}-#{tap.user}"

    zsh_completion.install "contrib/completions/zsh/aws-vault.zsh"
    bash_completion.install "contrib/completions/bash/aws-vault.bash"
    fish_completion.install "contrib/completions/fish/aws-vault.fish"
  end

  test do
    assert_match("aws-vault: error: login: operation error IAM",
      shell_output("#{bin}/aws-vault --backend=file login 2>&1", 1))

    assert_match version.to_s, shell_output("#{bin}/aws-vault --version 2>&1")
  end
end
