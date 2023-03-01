class Fdroidcl < Formula
  desc "F-Droid desktop client"
  homepage "https://github.com/mvdan/fdroidcl"
  url "https://github.com/mvdan/fdroidcl/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "4dbbb2106c23564a19cdde912d3f06cd258f02eccd6382a0532ef64e7e61f2fd"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/fdroidcl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c549d7f3ead6ac34d089bb3fc4f968efcdb111fba67021f79bb5fab8309f39c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "783ca1d4d51da20058631202f89ae23bab21f5b2d51e53d6c4d47e7710172a3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a97e452f11bdcc88f5da85554cb53672a1c0266d512515c3361773ba43ce158f"
    sha256 cellar: :any_skip_relocation, ventura:        "d64dfbd06d3c0f0d4f1350753fcd3fce58ee9bfcabacad7694679608a3775bcf"
    sha256 cellar: :any_skip_relocation, monterey:       "4058da1a3039551360e6bc57448e5b52885b858474af65ba118f487f19b9bc08"
    sha256 cellar: :any_skip_relocation, big_sur:        "e47a2f00c2f41b2ceb0dec399bfeff0ce72977bcb6d63d741111507bc13fbe10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b37f276bc7d4a1fe0b6591e2c555745cdf9d212ddab8140d5c0f09c8fc848263"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "f-droid.org/repo", shell_output("#{bin}/fdroidcl update")

    list = <<~EOS
      Connectivity
      Development
      Games
      Graphics
      Internet
      Money
      Multimedia
      Navigation
      Phone & SMS
      Reading
      Science & Education
      Security
      Sports & Health
      System
      Theming
      Time
      Writing
    EOS
    assert_equal list, shell_output("#{bin}/fdroidcl list categories")
    assert_match version.to_s, shell_output("#{bin}/fdroidcl version")
  end
end
