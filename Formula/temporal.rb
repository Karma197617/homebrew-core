class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/v0.4.0.tar.gz"
  sha256 "cb7980fddd2e276f263ba4ea2bb5cd4662ca3148f25118dcdb221a1672561b84"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bcc84075002e930e0a30f1a88937cc2104cd9d58aa69e13b957580913392f4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "750aaba3847539671941b17d1fd18a9d93cc901fd771fece5d2015ca3d5b7a08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cda4bb7592c192e3e1dac1f88a21564e6e1edfd61c589d46685645ff16a2cb5"
    sha256 cellar: :any_skip_relocation, ventura:        "aaf4f01b676aa91a9d311dd26989920994ae0c7d7764b68b8846506352fd8ca7"
    sha256 cellar: :any_skip_relocation, monterey:       "82ea2a41d3261a6973bf1cc49d12fc620a674df795a322726ebcc50166b494a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0765ebfde8d674eb9c9adafd8e33c32c2f1046bad061181a6fdb665e28629f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "059cb1c88cdb25f9c3433e5dd14540156b71d7e289d64f6fed9838bffb12ed6d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/temporal"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
