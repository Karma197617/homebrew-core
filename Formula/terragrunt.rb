class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.44.2.tar.gz"
  sha256 "e0ebb2d01d03809a36381e0f20778a4f77414f5885b9bedf637860cc6cd92c78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66e5c1aa735078933299f06f5839f58c3523b3262f777cb83487be9a50807a10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66e5c1aa735078933299f06f5839f58c3523b3262f777cb83487be9a50807a10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66e5c1aa735078933299f06f5839f58c3523b3262f777cb83487be9a50807a10"
    sha256 cellar: :any_skip_relocation, ventura:        "4d0a4e63094e50218f5a5508799f1ca37b5798c5562e2159f68b1a7b943137ec"
    sha256 cellar: :any_skip_relocation, monterey:       "4d0a4e63094e50218f5a5508799f1ca37b5798c5562e2159f68b1a7b943137ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d0a4e63094e50218f5a5508799f1ca37b5798c5562e2159f68b1a7b943137ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82a147d87a2fb68485cb90413f56bf42c47e55c35aa09da91c4e6169ed686b39"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
