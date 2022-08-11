class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.1/c/avro-c-1.11.1.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.1/c/avro-c-1.11.1.tar.gz"
  sha256 "12588c4e3103e7f44a1e05ab583f1dd04adaf6a10aa2fd73e1ccf59045535f92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e866c69e2e7cf6ed942aef633b01b38bbfd1fce8c9f2e6ab563f386c82652e5e"
    sha256 cellar: :any,                 arm64_monterey: "003f19bcd51baea53f86d97488f83552dc8477eedef78a371bdc166ac0d183ab"
    sha256 cellar: :any,                 arm64_big_sur:  "f30243ab877db4e81ff07c5dea0e266228ac04bf178144d3f9caaab45a876f86"
    sha256 cellar: :any,                 ventura:        "8b128950bcbd63c5f82e88773a0fcf5eac8c044f033ee5322ac4e35150fbd501"
    sha256 cellar: :any,                 monterey:       "35a23d1c97d7e5b50adf7ff2f8ff3ddcb6f9271c85fc033306e8447484e23b5c"
    sha256 cellar: :any,                 big_sur:        "cbb5817beab9e6dfb2dd1a5fafed449c6aa5dabf8525b71142854771ba46ab35"
    sha256 cellar: :any,                 catalina:       "d91479cfd09b368e971ed2c926c480edfe88f62df39476e780ec0d863cc19dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80da35f4303fb1c13aa3a8728d2e4dd35537ba984a075531c2f7d17f6d03e823"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "snappy"
  depends_on "xz"

  uses_from_macos "zlib"

  resource "homebrew-example" do
    url "https://raw.githubusercontent.com/apache/avro/88538e9f1d6be236ce69ea2e0bdd6eed352c503e/lang/c/examples/quickstop.c"
    sha256 "8108fda370afb0e7be4e213d4e339bd2aabc1801dcd0b600380d81c09e5ff94f"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("homebrew-example")
    system ENV.cc, "quickstop.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lavro"
    system "./test", ">> /dev/null"
  end
end
