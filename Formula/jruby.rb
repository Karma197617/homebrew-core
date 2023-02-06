class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.1.0/jruby-dist-9.4.1.0-bin.tar.gz"
  sha256 "5e0cce40b7c42f8ad0f619fdd906460fe3ef13444707f70eb8abfc6481e0d6b6"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e10434bb3c16e5d123b18f60f883dec4b4ae6d900857535cddf7673c82d73ffa"
    sha256 cellar: :any,                 arm64_monterey: "85ad1791e4ff53c32d71909833664d07d454ad4c72eedaa3dc0c4ce370ef65b8"
    sha256 cellar: :any,                 arm64_big_sur:  "47956affebfe8a3ff0d4acee88ce29390ce4a98398a97976d16597608cd8e503"
    sha256 cellar: :any,                 ventura:        "2e1e1d75461c59147d44fc7324de8cbf4d9cd849ff863a39cc334560afe8f2af"
    sha256 cellar: :any,                 monterey:       "08567a21953d8630baeb4de7d3e9e43e0c2b121d94addf71e31afdacda2a0b56"
    sha256 cellar: :any,                 big_sur:        "68ff6a2dd02efeb9895c08e0f04b4fcc8728d9357f47ccf0eb53d3eef7c847f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e8441a7185c77ecd9a4d9a68f3bcb494d6158d90b69761ba48452e07eb0d45e"
  end

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w[ast erb bundle bundler rake rdoc ri racc].each { |f| mv f, "j#{f}" }
      # Delete some unnecessary commands
      rm "gem" # gem is a wrapper script for jgem
      rm "irb" # irb is an identical copy of jirb
    end

    # Only keep the macOS native libraries
    rm_rf Dir["lib/jni/*"] - ["lib/jni/Darwin"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Remove incompatible libfixposix library
    os = OS.kernel_name.downcase
    if OS.linux?
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    end
    libfixposix_binary = libexec/"lib/ruby/stdlib/libfixposix/binary"
    libfixposix_binary.children
                      .each { |dir| dir.rmtree if dir.basename.to_s != "#{arch}-#{os}" }

    # Replace (prebuilt!) universal binaries with their native slices
    # FIXME: Build libjffi-1.2.jnilib from source.
    deuniversalize_machos
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e \"puts 'hello'\"")
  end
end
