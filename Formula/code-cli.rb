class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.75.1.tar.gz"
  sha256 "97500f244eacd66556c2bcf2d9a63b2509e363f9bc8d587c6fc2feb6bb1a5e31"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8545a885cfee62bf1938756728fd998b9c4919bbe116bd1e90902875b3222b1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc7a03d15e3a3283bc8c3726491ccc11bdfd933cccaeac5426f192a045408add"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "993809d75b98ed7f7ba3a0fd797631fdf47544eb673c12f5044255e04d30127b"
    sha256 cellar: :any_skip_relocation, ventura:        "3a9f13f2401d02076b5f565ac57b5d68b2356513d473ecd7bbb3bc2e4d28e1a2"
    sha256 cellar: :any_skip_relocation, monterey:       "b07fb6bb7dc352b1f5963774f8371668a974e45c5d8cdfb71672caa059e7ea7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc9818fc24a6d243cb147b06de33ac152c0e3d0c78b1550816d51f3c23e827b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "936c595d5b9b4606fc54cbe6a4008e4291f88837e247c061d081f2902bae0651"
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
