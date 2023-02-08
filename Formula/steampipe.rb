class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "4408546dcb56e55684cd51323386b1a6113f86763674be75c903cb74a1469f27"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18ee4fdb6a9858e4fc270751eaae315484777114a2bb8c86927e31bdc59d616a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "077c0fe5be190b204a39b8daf4b8a905855c8d7168476bc3164def09d188e6dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81c623e73adf2faab168d3f94cc4caceff6e0dc93b2e9c3dd3f7da2ed4deaee7"
    sha256 cellar: :any_skip_relocation, ventura:        "25e290201cbb89e7a9acf93528cc15eca47050eb982c5d3ee1915e504d04af75"
    sha256 cellar: :any_skip_relocation, monterey:       "e5bcfbc0d29a80077d2f8dd1b6968cb06b621135716d1cbae555f2512758d414"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5193853c3f7958fcc1764508faf3f61486b0c7f72fe6d6a8ff64b633366a09a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c20b89b2aac9705a883622cbf8fec4d8dd61ab7d14bf9b3c0848e6f228563f3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    output = shell_output(bin/"steampipe service status 2>&1")
    if OS.mac?
      assert_match "Error: could not create installation directory", output
    else # Linux
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
