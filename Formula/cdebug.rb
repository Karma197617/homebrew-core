class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "83ee00f576d4aab396a812ee4c6e1f309dfd8543afd5f48897f706b8b548df2e"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88d2982c1ed4eb4cadb8096d10b0076feed71804dabf76d556dd343c79c31b43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc31a806ea0357e8915951be20a1b9936ee0893607b1df1ff7bb906a3103cdb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eb38f9940de8666cee4a8ffff32ebd4045e7c1a28e74dd2d5998c9123e46f1f"
    sha256 cellar: :any_skip_relocation, ventura:        "7819ed50867fea255652a22e7fcc89c6b9e6c8e4d69d92e8b0297c6501d96d8a"
    sha256 cellar: :any_skip_relocation, monterey:       "93e077c9a35d99e435b47d27dccb72aff15f45af1a9dfda592594873e7a1cf7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8756dd4ece7c7f597ff23716cdce1ff9d14fc5eb5dca1ed1021253b1f2f73993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3079ddc6fc91ed94c804bd0f161e7e6f5ef78de1210d2270e3f609fdb097f521"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"cdebug", "completion")
  end

  test do
    # need docker daemon during runtime
    expected = if OS.mac?
      "cdebug: Cannot connect to the Docker daemon"
    else
      "cdebug: Got permission denied while trying to connect to the Docker daemon"
    end
    assert_match expected, shell_output("#{bin}/cdebug exec nginx 2>&1", 1)

    assert_match "cdebug version #{version}", shell_output("#{bin}/cdebug --version")
  end
end
