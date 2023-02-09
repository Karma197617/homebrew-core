class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    # Get long hash via `https://hg.mozilla.org/mozilla-central/rev/<commit-short-hash>`
    hg_revision = "602aa16c20d47216f2e4a3b8877c3e34ca947f33"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.32.2"
    sha256 "7dd4c132ddf3f15c65a5b8b764afc6708ac5c9a4b19d3f9844cd59412bca6ed6"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "074dbee7f7d55e95b539eaf119aed2166852d2a2613fd8e6f52fd73fb547aa7e"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "24413a09a7df9545f4aacb36ec156531369935f5ca861bad5ed793029b00a005"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "1c1f5dfeef8e179585f45f7593f136e4e819c00dd5bc23fe30abdf2399aa6504"
    end
  end

  livecheck do
    url "https://github.com/mozilla/geckodriver.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94d39d90d9329ff490ebaa8ed4d8faf6c7f40c79decce13dea1c5b14f0eb0d34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c01ff5a822a208780e2a497ac8909c8b62c54f04320c312f6db565491d3311d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb1aa2a8d8b0728f7a555e646a86d83da9decaf6ab694e0504a67f8969a658c8"
    sha256 cellar: :any_skip_relocation, ventura:        "922e533fecf12646c1b28653caa6b3de4737c36925fc714884834a26e588d172"
    sha256 cellar: :any_skip_relocation, monterey:       "58a5f46bbe31b63f6bf9c4fc0ce7274d544b1d07aca2d6c45ddde8265aa3b880"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f99b93321b15e32b44aa3b418496003e69da0f3354dad3f5d9d257c55805dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d81941c3ac98a6f43e21726f9672939b1a760907a1f547d5952fbac81ede6182"
  end

  depends_on "rust" => :build

  uses_from_macos "netcat" => :test
  uses_from_macos "unzip"

  def install
    unless build.head?
      # we need to do this, because all archives are containing a top level testing directory
      %w[webdriver mozbase].each do |r|
        (buildpath/"staging").install resource(r)
        mv buildpath/"staging"/"testing"/r, buildpath/"testing"
        rm_rf buildpath/"staging"/"testing"
      end
      rm_rf buildpath/"staging"
      (buildpath/"testing"/"geckodriver").install resource("Cargo.lock")
    end

    cd "testing/geckodriver" do
      system "cargo", "install", *std_cargo_args
    end
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    test_port = free_port
    fork do
      exec "#{bin}/geckodriver --port #{test_port}"
    end
    sleep 2

    system "nc", "-z", "localhost", test_port
  end
end
