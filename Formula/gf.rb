class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "2897b91a92c3370a41d9f7d3c8c78a86752ab83d04de77a09a5eb244f1c031dc"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "787f1a112642436a865d2b5418f1adfcc0b5f4f55799a3fadb99b8ee10008921"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76e4078db2aa6992c852df6effea40310d932619c9496d8b30083ba88b9fbe69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6f4da64a24f76f362a5998f065b18d4097cb24d2f6d2ea5fdaa11fe1438d6ec"
    sha256 cellar: :any_skip_relocation, ventura:        "217bd5c07bca074f30765e29a6df6ef2b51a89627f43c783ecacb04eeb5529f7"
    sha256 cellar: :any_skip_relocation, monterey:       "11d6e449515e93472e5bb2d53e5f02f4cd4accf8e72a2257ab721ae7886959f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce32ae140772c3422f41e0ea1fc17c21b5c677aae3c948c4b2cac660bdfa2091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c062e4ab1d54a8bb42179488ad8a0027d50c5a60b80f3535080790daeeb1141"
  end

  depends_on "go" => :build

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "GoFrame CLI Tool v#{version}, https://goframe.org", output
    assert_match "GoFrame Version: cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
