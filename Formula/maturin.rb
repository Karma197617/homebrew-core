class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.12.tar.gz"
  sha256 "b1b665ffdfe6fa7f6f7e3ee2b7c3927567dbebea704141ab30dae3a88aba82be"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b375dac6b52fd21cb13ffd925f06bb8c0fc77539c664c0addcba6195f7a24335"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4099d43331a621255bef395454e3b2fe22ca74e92c2f6ba08cff937b95ffbe01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c74a45b88a05913ed66ac6a59027cfefdf57469ef6d19c0938a0000ffa8dbaf1"
    sha256 cellar: :any_skip_relocation, ventura:        "83b81c3103c2d12c5461e33c83eb52a7067935a33d7e706e0b78cca33e84f253"
    sha256 cellar: :any_skip_relocation, monterey:       "42332e29a2d1826f2ec8c5eeab731b9d13f7b9b44d20fc3f713aa1c2faa757e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "def5fcfb3c57bbfd79065ea404808d23c25541c38b9ac2e6710707b4cd825300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c1b81cbe65867aad798be7d50a8332f181ee36862ac7484333fa5f47f1766a4"
  end

  depends_on "python@3.11" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system python, "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
