class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.65.2",
    revision: "eb1f3b7a4b174eca3304637eb2305fc8cdf32291"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e7138dbf1762263677bfecb3e77fb80ecaceb468cf9d0cb800071f52eeeda75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e606ecdd7716908f413f8b21685b9095527ca53c5a8dae86e46a2002d20a6024"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6da5c6d9ce13475464fc7594247656663eb64fb085b97baefaf123ad33dd1c1c"
    sha256 cellar: :any_skip_relocation, ventura:        "128f44573f7f668062bc1b34dedc426deca07d15e1f10aca50477d7940909b14"
    sha256 cellar: :any_skip_relocation, monterey:       "87aa33a015712ac0e56caa91cf60f414a7cae54329ffb65efcfc8ceb0f8617ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b465bc78f59388a33a398a2fe7a34b61ed2f7498fe2e3858abf89751877ee8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77bf6b41cffc9398289d5cde82d25cb1d5a73d2489c1544861db8d18491451cf"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
