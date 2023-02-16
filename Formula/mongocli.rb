class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.28.1.tar.gz"
  sha256 "2345ab3029b6fdf293a23a389f86fc6f866da2bf0290247fbd769777b5ccc2ff"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07dfaffaaab6651af53849c1a8450a514888790362236ee038c85c3764e80bc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5d29d1b85af429a17bd1b306300d05507adb6e0720d80b69e4a9d5604b0afd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e018680c6913608f16f4518c3e32601151198672c0988410b1724a0fefc724c9"
    sha256 cellar: :any_skip_relocation, ventura:        "7e6dfcfb0ef40b3a42a794f09ae8bd563e8113cea90341c6d41cd15c4116c7a9"
    sha256 cellar: :any_skip_relocation, monterey:       "66ecf32edeb131e23a45d0100cddab5ccaff990f78232f98c3657c7985ebc787"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0b1541f6938d6305ff05a87f1bb14e69cd214be587398c7888fb519412b049a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05d77d5f34b76714d380d27006c6cfc58a50c3f8cd5bf244e48e839eef46c099"
  end

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", "completion")
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
