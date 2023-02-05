class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.65.0",
    revision: "c31eb73d40477ede8721aff8bf88171ab02fecff"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0320320e5905c1c73820c823b4ddf28b53524d80ed839d71b844fdf1ae5bc64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ed02a35c26c939934b89f9f45bac6c378d9d9440437d5331ab2c69a0459351c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da7df7d78e0be74458559bb4b6af673a1099ebd10649285d7c78e9a3b443c171"
    sha256 cellar: :any_skip_relocation, ventura:        "88b442afaf4580bf9abec6bc61bbc3fdffe0920f10c07af2217074e6d585f57f"
    sha256 cellar: :any_skip_relocation, monterey:       "77f13d016128d44b91564e5f3c2e2f46e7dab6c1adb271caba864e7c264b72ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "524bd197c3413a5bec8ba290d4af79288d1aa18c2842e0dd6d6cf533583cd074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e1fdd489274fbad4f319efcfb73041e227604d7da0b11a8ec0f9603ae6a5734"
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
