class Tart < Formula
  desc "macOS and Linux VMs on Apple Silicon to use in CI and other automations"
  homepage "https://github.com/cirruslabs/tart"
  url "https://github.com/cirruslabs/tart/archive/refs/tags/0.36.2.tar.gz"
  sha256 "5f8e3b1d92907a1c6949ac8430ad1c48f24d28e8af73dd28b7cc87df69401eef"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ac418f4f0b1871ccf6f843bc68444481b8b2071f6a15db42fd6ce55104aa2a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03454be44162d31f4a6a0fafafa4926166913f5d116c202881c78ffefb533588"
  end

  depends_on "rust" => :build
  depends_on xcode: ["14.1", :build]
  depends_on arch: :arm64
  depends_on macos: :monterey
  depends_on :macos

  uses_from_macos "swift"

  resource "softnet" do
    url "https://github.com/cirruslabs/softnet/archive/refs/tags/0.6.0.tar.gz"
    sha256 "fd01589b9cb1497394f1fd0fbed385dca51558352b5a7d1337cb92a1a2d2f95d"
  end

  def install
    resource("softnet").stage do
      system "cargo", "install", *std_cargo_args
    end
    system "swift", "build", "--disable-sandbox", "-c", "release"
    system "/usr/bin/codesign", "-f", "-s", "-", "--entitlement", "Resources/tart.entitlements", ".build/release/tart"
    bin.install ".build/release/tart"
  end

  test do
    ENV["TART_HOME"] = testpath/".tart"
    (testpath/"empty.ipsw").write ""
    output = shell_output("tart create --from-ipsw #{testpath/"empty.ipsw"} test", 1)
    assert_match "Unable to load restore image", output
  end
end
