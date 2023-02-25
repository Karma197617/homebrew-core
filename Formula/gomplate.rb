class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.11.4.tar.gz"
  sha256 "03d2ca995ec470293cbf7446c8f6a79b2a9fa8943fb51025139dca7810f1431b"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c05588c8c729ca113fee428653b850cf4fd16ff2b6ba459ab10c8f2aee9cc882"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd4fb2649d00b524e5246d9a564b16e7480ebef52aa69021bf93f1b287025141"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf5d5d2764fc6473146769f85f06391765d14936bb6cd663861883aa855f4107"
    sha256 cellar: :any_skip_relocation, ventura:        "1e40641b772f5e01865d4e6e3e5fe81ec808ff084b0d9e1180ec536a3ddcaa5a"
    sha256 cellar: :any_skip_relocation, monterey:       "820d9c3fc7735b4f9feb4666d29647e94203a7c9401c23dea44b335bee58db1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "63048888c30c332cca0e300f0fd095e6d6d1d981ba3cae1691304b9225eb2187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f9863a55d812073a3178688c987e123d8fd634e8fe611a324150c73f0f8c2f6"
  end

  # upstream issue report, https://github.com/hairyhenderson/gomplate/issues/1614
  # update to use go@1.20 when the issue is resolved
  depends_on "go@1.19" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/gomplate" => "gomplate"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/gomplate --version")
    assert_equal "gomplate version #{version}", output.chomp

    test_template = <<~EOS
      {{ range ("foo:bar:baz" | strings.SplitN ":" 2) }}{{.}}
      {{end}}
    EOS

    expected = <<~EOS
      foo
      bar:baz
    EOS

    assert_match expected, pipe_output("#{bin}/gomplate", test_template, 0)
  end
end
