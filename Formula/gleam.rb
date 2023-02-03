class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.26.2.tar.gz"
  sha256 "96b7f14e7cb5428e82b36d4d7a7bde3067a849c4bc8486b1b5caea49d5e5bce7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5db27bcb949351d293d5053052cc9401978792b86999bbe5eb7d96a846f49fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "025849b16aecf43f33cd0941a39e0bb1879ac92cb919983b1768d24e2f13a782"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e50114d83955a5bb13349af9a938cf3586a2eecebc0cf335e8a65d95b17d0e21"
    sha256 cellar: :any_skip_relocation, ventura:        "7941738f06037dc7b4fc871383acb7e58e5fc9478cd793012d0d29a19da4261e"
    sha256 cellar: :any_skip_relocation, monterey:       "8141c2911c6f09e4b6fdfcf773e36ef6b603652565f975c41319c98109b16b92"
    sha256 cellar: :any_skip_relocation, big_sur:        "dba106413f10e47e894f9f69eacba8540e377e4bd979f652a2f044a35a2ef204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "697266003ccb9b6afd7b9306f0692d97cb845e94cbbf70e2bdc6c7bd275a74ce"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "gleam", "test"
  end
end
