class Xurls < Formula
  desc "Extract urls from text"
  homepage "https://github.com/mvdan/xurls"
  url "https://github.com/mvdan/xurls/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "8c9850c80eff452eeca2fe0f945a33543302dc31df66c3393ed52f6d8e921702"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/xurls.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/xurls"
  end

  test do
    output = pipe_output("#{bin}/xurls", "Brew test with https://brew.sh.")
    assert_equal "https://brew.sh", output.chomp

    output = pipe_output("#{bin}/xurls --fix", "Brew test with http://brew.sh.")
    assert_equal "Brew test with https://brew.sh/.", output.chomp
  end
end
