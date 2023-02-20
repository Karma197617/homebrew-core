class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.8.5.tar.gz"
  sha256 "ccd04107e02443d8284521beb5f88a3c3bcdc4b18ac2a2c1182d78bb56361c88"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7693fafb33a19efb94d8fc43785fef33dac8de79440e8959b4e41c1f65b9451f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a18eaa404b10b41037a7a7710cda8366b4d5942d038efb503435b9405dbe94f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ee7fa2812469853b2406985ac9c829c1e9bba45a2b660fa00076223a6431b89"
    sha256 cellar: :any_skip_relocation, ventura:        "e296b664f2f626765890111d3a87805425c96166050e2ea10973d8a50bf3c178"
    sha256 cellar: :any_skip_relocation, monterey:       "965e18eb4de0f5dbd30129c8402985f9797449903c91a167fbac0fa705e6adc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd73a1f3710b0f8cf7e00dad72226a044277197438310c68311aa3f32babff31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06d85cedb62bbb676d40c2a6d17a8ed82313415574debe0c0450df58bf319a9d"
  end

  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk@17"

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
