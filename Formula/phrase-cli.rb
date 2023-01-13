class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.6.3.tar.gz"
  sha256 "dacdd29240c942ac7c84e76b79e8931928954df3f687d7de38a93f138d97ab94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d25d9ddcbf1272f8c6a5eb618410f41586c766c2dbabc66d32bc8eebdab5fabd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "114783582fdc6e14dfb166ba131326289339ef5bf0b34608ab5d37d3365ceec6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daadbcc3d43481fd28a2e4d56a77c08bc73d1a5930e0061a33ff0c5fbad4c508"
    sha256 cellar: :any_skip_relocation, ventura:        "4ee1a45e019b2c2aba631fcef6ac6daed418262a14e51900bdd3b773ee8ae2c0"
    sha256 cellar: :any_skip_relocation, monterey:       "b7d4c06ac913b6e2c084ec97a277b300625d3a2062737e12f2d69d89b7f28c3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b38b97cd5ac4143ffd656be9f6e3cb273f60cb9cdb830af30b165d1f0a5f6a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c8c3494241b58fe13bcbebd2508c142c316f21209354424d4b7686392a76a74"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
