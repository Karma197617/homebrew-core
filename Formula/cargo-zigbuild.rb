class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "2e9fb6d1132f863e7a3eecce09e041bf8d43144529e334c9ad50be989664aecc"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7eea50b6ca007d5a7dfd1399bf0905ef87dbd3f4dc7410077c87a66e066f8a04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7f308230872076b519063dce0d6a8b78c6c1035717c1efde8c0feec30d0ca52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0ff2ce89ba76a393c91575cda4b376b1060fee52b4b59fa418348ef23491683"
    sha256 cellar: :any_skip_relocation, ventura:        "1bff045a8ee787a15eadac9ad9bcfa9ee69b03e60e4bf21407c7ebb362503b81"
    sha256 cellar: :any_skip_relocation, monterey:       "17b0b669d33e50027ad55c86e15e7f15857f15ad02d292572c08730d9cd90bb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a36c7259a24c3260e795085c108428745e7608267f15b5c099684e90c4d0335b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d3f09083119c33aac2c7a75f24e00a5c24f38a5f6f8cfc85f00ef686f63615f"
  end

  depends_on "rustup-init" => :test
  depends_on "rust"
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Ignore rust installation path check
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    # Remove errant CPATH environment variable for `cargo zigbuild` test
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
