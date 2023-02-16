class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.5.1.tar.gz"
  sha256 "b5bc79df19169a9fe9136c78e3701a32e1f88ba5c370c3daa763dad7f667c42a"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da3ca7146ff8d4229ed5171b0a4f94afcc1097208927efa447eddd767ee67157"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27d9c8209c7b79c9b7d8e22fc357a734a82951b5f2754603e9b8024ce9476c43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e63e642f9f7b82c19583fdbf29975535e41d48191a3fec2f774deb240c73d336"
    sha256 cellar: :any_skip_relocation, ventura:        "4ca9069cdbddc836c0d044cdbe840b8adf79d20ebe95959527b5ee78c1e18620"
    sha256 cellar: :any_skip_relocation, monterey:       "8b44d2c3c2097a04f86618af2a373f84a6e87d5aa90958adce7816b662ffb8d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "68903e166ba240732027bed092652e59fd7bb883bfa03afa8b08f267443060de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d4186abfbc9da1cd9cd8c11098d4ba620732f614ec412dae016c2c2daa2ebb"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  def install
    with_env(
      ATLAS_VERSION: version.to_s,
      MCLI_GIT_SHA:  "homebrew-release",
    ) do
      system "make", "build-atlascli"
    end
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
