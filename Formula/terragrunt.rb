class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.44.5.tar.gz"
  sha256 "86a3b534959fe50e97a08fbb18332ba432ab1ca4cda534f6af0ceddd5938a568"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d92a1fe6197fa84419060292b46cfae216c9165b9fdc1f49b28479cc70f4fe43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d92a1fe6197fa84419060292b46cfae216c9165b9fdc1f49b28479cc70f4fe43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d92a1fe6197fa84419060292b46cfae216c9165b9fdc1f49b28479cc70f4fe43"
    sha256 cellar: :any_skip_relocation, ventura:        "a1bc84ffe02fa7699457d247ded3830fdc76d060227b5a657dcc034cc236b600"
    sha256 cellar: :any_skip_relocation, monterey:       "a1bc84ffe02fa7699457d247ded3830fdc76d060227b5a657dcc034cc236b600"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1bc84ffe02fa7699457d247ded3830fdc76d060227b5a657dcc034cc236b600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac5be9e2e32123845277043dca229ead1aad0c22b0c559d0390d8a34fa8e34af"
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
