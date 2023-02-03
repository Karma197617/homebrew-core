class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v22.tar.gz"
  sha256 "21b555f7850f94cc42134f59cb99558baaaa18acf4c5544e8647387d4a5019ec"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://github.com/cjdelisle/cjdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16f328c324d814cb4e8f640fd582b94baa59dc0f46486b0f36c2a526cae1b411"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83df6698c19323e2bfef31db842073404c7b32b92e0930f87c266ed28840febf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6aade619d0ed1a435ef4b9a2dec7f06b789c19c7fa2bcea0f526b9a9034129e"
    sha256 cellar: :any_skip_relocation, ventura:        "144231af0cc71773357c1e5f8bc44a372b12c1544842d6d4a4ae8e9ee7f1d3a7"
    sha256 cellar: :any_skip_relocation, monterey:       "bb657ba499e1644b556eb609b7f8a0354fc850719c7ff4f44ac317e266f60fd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8a9025d30e0e861ffdddd5a753926dc503eb7d7e9ea815773b4944da56bfe13"
    sha256 cellar: :any_skip_relocation, catalina:       "af362a1e5aaf21b04763557b7bfde820d28da74e7a072be24aba6b0362ab9ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7717c4aa96f3cd4286a9848870252ad60d9290c2d6026d409d257463f2c42bd2"
  end

  depends_on "node" => :build
  depends_on "python@3.11" => :build
  depends_on "rust" => :build
  depends_on "six" => :build

  def install
    # Libuv build fails on macOS with: env: python: No such file or directory
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin" if OS.mac?

    # Avoid using -march=native
    inreplace "node_build/make.js",
              "var NO_MARCH_FLAG = ['arm', 'ppc', 'ppc64', 'arm64'];",
              "var NO_MARCH_FLAG = ['x64', 'arm', 'arm64', 'ppc', 'ppc64'];"

    system "./do"
    bin.install("cjdroute")

    man1.install "doc/man/cjdroute.1"
    man5.install "doc/man/cjdroute.conf.5"
  end

  test do
    sample_conf = JSON.parse(shell_output("#{bin}/cjdroute --genconf"))
    assert_equal "NONE", sample_conf["admin"]["password"]
  end
end
