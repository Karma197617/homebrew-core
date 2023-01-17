class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.6.4.tar.gz"
  sha256 "e2e12c293dacc3fc9cd73df8dfb5d7b3adcd5bae2cf3b6c993ae3e72d7aed4af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2224ae62a2bfa73290f6194501b83383114e328334ce6998d6e6256a3a4ce78f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e37167efec05e1c0349663212ddadaeb75d96ce5f3b656a95e70a2a7bf44b009"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec15a18fcaba3de5c88ce0baf5fc1c7b52d61c7db3def309282eee33a0073b27"
    sha256 cellar: :any_skip_relocation, ventura:        "f8b9fe6f9469e284df6c3230be2ef54bbbf5a3920c2f5fa1de52d7e8fd152c57"
    sha256 cellar: :any_skip_relocation, monterey:       "99e0a99ce253d5c49d6fed8150b1866a70d5e9e8dd4a1aa620bee7174e37b7ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "30a7a41f7491d9119abed76e51966590b8b0c027cae726b30b522d21b124caa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f62e3032bdc15ade739c6cdd8cec63f1b6615513c2ab01968022072f3bf5bb8"
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
