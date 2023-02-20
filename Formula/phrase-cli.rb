class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.6.7.tar.gz"
  sha256 "2caf73409cbd58a11df36537a312e1685aa13b9f46768198ff523464f1a256ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "428e090c18907a5000883bd72fa2315be6b75f8850a2334c5529df00bc7e7bd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3019395b11525765ac14429190ab89c54b82ca23f284fd3c7fd9f96ef3beb49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ea625e737928d1d0784dbb3ea954b11447bc7fcc562fb858f6793c1126677ff"
    sha256 cellar: :any_skip_relocation, ventura:        "999764334e6cba95cdb4916c908a6e84c6c29b27da0774c72efd64fb5990c38a"
    sha256 cellar: :any_skip_relocation, monterey:       "288c0efa8ceef3479fa6bdec5d8e192b7aead295aee1b032d03e78f6fe4a314e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce555ee5e4ecd890b0fab0bcf5ef6533544038de076f5a434af52f122ea5abc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fe25b52dbf9346173138138d9d98c8641daa392102ad4bf7906472d6eaa6be4"
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
