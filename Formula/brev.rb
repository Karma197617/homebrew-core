class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.207.tar.gz"
  sha256 "cac215ebe4401e96987697577447703aff0ce5cba09312689eab79d955723b84"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfda56ea4cd4ad93282f6af5a8263d3421413c0d447b6a096f9cef84b4ffc4ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d62d01b4de82066d94ba9cefa21e1838ade2b60b94e7cb135bd45a5602d33c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "204b2536fa2a1cab6248fc0a4b4ec00cb57b8ae806c060aba4a07c9194075352"
    sha256 cellar: :any_skip_relocation, ventura:        "174e8c5b00930b0ab799b3c2a4a9335feea3c93c49c74195cd707c537953f7d4"
    sha256 cellar: :any_skip_relocation, monterey:       "401f75d8bea3e869df0722fbd784f6d316bc44825774f561c61e822f24ca6eec"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f8ea1d6b12f544e452b268b7cd8cc01566d32288081f707316968f173bc6857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a904cca884936c0db08884cda5490f8292b06167579074057ee04f40883625b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
