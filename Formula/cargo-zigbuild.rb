class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/messense/cargo-zigbuild"
  url "https://github.com/messense/cargo-zigbuild/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "a6f855a011062cb19c7e921aeeac1188edca9ae7ac0c845bc1346921ea982feb"
  license "MIT"
  head "https://github.com/messense/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6347ba1ad7a3fcb2bf6b799a387fdb2b7200f6c266c8de6459e6d9148171af5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f78726ff686cea2d6ca6ca7347e3fe35346a540d39ee84d73c10fd9ee8a5f781"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e38d85f2d9a4532752a68851256c35308c732cdc1caf4a51927fa71fc0aadce9"
    sha256 cellar: :any_skip_relocation, ventura:        "bf6f1298e90813d5b82cb0dae9eaf7381f5dd1532a882b082b47d0ea7a198539"
    sha256 cellar: :any_skip_relocation, monterey:       "f1756841aa724bffc12a9a74c9aa60f6606e8c66fde362b0c82bcc9bd3d1ae31"
    sha256 cellar: :any_skip_relocation, big_sur:        "d49b6ad2483786853af00ce0d8e93c0e048ff6c5f903515166f426ab47ab7b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90fa2b46335910f20fb8c2146458efa3b0495d4c1a78d7c4dd147478b2ed6812"
  end

  depends_on "rustup-init" => :test
  depends_on "rust"
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu.2.17"
    end
  end
end
