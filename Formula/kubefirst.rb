class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/1.11.1.tar.gz"
  sha256 "8f90a1b83d88f0a7c383da7b8dfc7c606400f6e0af8e98daa687b8e67c265d20"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e317bf9e3fb57bec5bdf5e13b6ed4ae2bff6a2075242387bd954f2834b88f751"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6379b90936356ff2259daef1aad9b1957cc4f4e521f25c3fb905b16ddb6cce8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e862d65cc4c51ee677e66e84a60ddb6ad706bad48cecc447168ac8ae956826b"
    sha256 cellar: :any_skip_relocation, ventura:        "98e5294942a4a76a33ae686776d2c0b923d851eba9fd710b01a89b16208bf190"
    sha256 cellar: :any_skip_relocation, monterey:       "f26c4d2922fca7ccf7f0dc48b67fb28b6f9afcb6a81f60b19859c96d654664dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d0d3954516306b5316714d14ed77947cc459a2db2395567fbbd623091386386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb39b73ba94f52879fa4fd3c0ce75ebd893511edecbede49468c4a12d32f6720"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/kubefirst/configs.K1Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "createdby: installer", (testpath/".kubefirst").read
    assert_predicate testpath/"logs", :exist?

    output = <<~EOS
      +------------------+--------------------+
      | ADDON NAME       | INSTALLED?         |
      +------------------+--------------------+
      | Addons Available | Supported by       |
      +------------------+--------------------+
      | kusk             | kubeshop/kubefirst |
      +------------------+--------------------+
    EOS
    assert_match output, shell_output("#{bin}/kubefirst addon list")

    assert_match version.to_s, shell_output("#{bin}/kubefirst version")
  end
end
