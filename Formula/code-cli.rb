class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.75.0.tar.gz"
  sha256 "719c1efeca10a163b18618b5b689d4843247d3e86a27a6e898113219274cb99c"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28ecdc93feecda8a4f0f048d48fa7454c265bc1a43300918bf0b8d8929ab9989"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c763500a0366eb14e2510294f3ff9ddf57eabb3a1a504f6067bc40947296a265"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "028035bff4e2cee441803029e6646d67d0061503f67a2c3880caed5dbd1d9c26"
    sha256 cellar: :any_skip_relocation, ventura:        "47bc40292da0d5c63bd84b9b8690814b7b76823f79bb2d324c35a339635e5a7a"
    sha256 cellar: :any_skip_relocation, monterey:       "5168c35421ca2e806c8a3a5124dd5c5de68f84500585baef3b2dd980218511ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7c94092020d36e040a7e5a50a39972241beaf2524b17081bc24e160cc72cdb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2f136e967933ac150818f1f40241c40b1879c595e775ca838003600ec04d3c6"
  end

  depends_on "rust" => :build

  conflicts_with cask: "visual-studio-code"

  def install
    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")
  end
end
