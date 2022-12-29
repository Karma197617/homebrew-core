class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://watchexec.github.io/#cargo-watch"
  url "https://github.com/watchexec/cargo-watch/archive/v8.2.1.tar.gz"
  sha256 "70f8e6d7da016062aa085cc2d86b2467482249d0e4ea0610a54b556890e24153"
  license "CC0-1.0"
  head "https://github.com/watchexec/cargo-watch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e16f13574e9c7f952e82cae4eb8cfd459fead9c5409df0a70c826e5134eb0cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67df2f4923a5bdc19be044e9084fa327937b605c3ef9ffc79db5905196df05ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebee4e05fdaa9d34c3c4c41149c8c872a461deec949e4ab5b338610e87cd2992"
    sha256 cellar: :any_skip_relocation, ventura:        "dc4a79c842e8ee437d8512c44e6376e5ebe4108fa6cd040f0ed4dd0448903122"
    sha256 cellar: :any_skip_relocation, monterey:       "11bb1331b31c171fe8b258af33a905b5a9ae68070e6c0d7ada9a5a400eaa8a34"
    sha256 cellar: :any_skip_relocation, big_sur:        "87b30b747d69b45eb11030fd8f85e7c853fc71087830e131915bbff5ee227076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "157894fb6b75dc740435750e556c014fb2414225b78156d4742634768c4dcfdf"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: project root does not exist", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
