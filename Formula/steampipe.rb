class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.17.4.tar.gz"
  sha256 "e754c17b1acbdd17104591b9bdd72433f8bc22d3918c465a734543c19245c5fe"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    assert_match "steampipe interactive client", shell_output(bin/"steampipe query 2>&1")
    assert_match "Service is not running", shell_output(bin/"steampipe service status 2>&1")
    assert_match "steampipe version #{version}", shell_output(bin/"steampipe --version")
  end
end
