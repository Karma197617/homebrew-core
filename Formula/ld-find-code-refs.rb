class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.10.0.tar.gz"
  sha256 "c4192ecb9a281906425f37bbfd43626d3f3e78b643c9cde28b59a16c1d340258"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d2d6cadb7fae31b819c773498214b5721c0ba17bd8645ecd2c089a49aa8d4ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07e81a3cdefc846241e4d8bb04b0e9fd484a98a863dd9f3dcba348db4d010e94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02b3c485b15eba6c81c2ca1d2dedb9668d36d55ec430d6fe5491944ff8ecf904"
    sha256 cellar: :any_skip_relocation, ventura:        "134dda501994d940e121114669c4e18ed49d3eb4c6c566940ab6346eed2e2d1a"
    sha256 cellar: :any_skip_relocation, monterey:       "e3edb67dc002b506294a4fcde9a28586b615600e576f0dfe823c84d1a19378c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d569479e66ec192321bf4efc4c5927c7092c8dc8aafd192deffb2fc74b0d47c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94013999871e2baac8d011c495008aab1d98fed5786262a00f4f2b6dbf5df3b7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ld-find-code-refs"

    generate_completions_from_executable(bin/"ld-find-code-refs", "completion")
  end

  test do
    system "git", "init"
    (testpath/"README").write "Testing"
    (testpath/".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"

    assert_match "could not retrieve flag key",
      shell_output(bin/"ld-find-code-refs --dryRun " \
                       "--ignoreServiceErrors -t=xx -p=test -r=test -d=. 2>&1", 1)
  end
end
