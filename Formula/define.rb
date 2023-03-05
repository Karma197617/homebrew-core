class Define < Formula
  desc "Command-line dictionary (thesaurus) app, with access to multiple sources"
  homepage "https://github.com/Rican7/define"
  url "https://github.com/Rican7/define/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d4b85395f941fdbb558e737a3a96b9205bae7ac6fb1d5bdde4121dc1f03a9036"
  license "MIT"
  head "https://github.com/Rican7/define.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Rican7/define/internal/version.identifier=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "Free Dictionary API", shell_output("#{bin}/define --list-sources")

    output = shell_output("#{bin}/define -s FreeDictionaryAPI homebrew")
    assert_match "A beer brewed by enthusiasts rather than commercially", output

    assert_match "define #{version}", shell_output("#{bin}/define --version")
  end
end
