class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "e374dbe54800dda40ed97df18343e0f8d7b8cf7d001d4b5db705c96dc27802dd"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fc4ef101118fdb6815675415739fafbd40773e465976dc9f8e1a4cdc3b107fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "264f151a9baa5e2e8249f6235397a3863fdc00f91a8b6f40126300ebafc55460"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69d8d6ffbcacfae36b41b6c09ab1d7fce2966a892bd168d728525491a3a3f32b"
    sha256 cellar: :any_skip_relocation, ventura:        "285540a1cb8cb04b3c5e46fcf359214ce62207e25463907cffc4057db6f40ae2"
    sha256 cellar: :any_skip_relocation, monterey:       "d5e3afe95b30ea959be168de26727b3fcfeb5f25e84b902e81ae38ab5a4fc265"
    sha256 cellar: :any_skip_relocation, big_sur:        "293e44c454c1104150583e0ca5253ce85b56edd1d5d51d76d355c1b7f61b3478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "793f2558eb4c138dbd1acf36bb84a1d94130e596caa7f86beb4e531a7e4479db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    output = shell_output(bin/"steampipe service status 2>&1")
    if OS.mac?
      assert_match "Error: could not create installation directory", output
    else # Linux
      assert_match "Steampipe service is not installed", output
    end
    assert_match "steampipe version #{version}", shell_output(bin/"steampipe --version")
  end
end
