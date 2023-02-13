class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.02.13.00/wangle-v2023.02.13.00.tar.gz"
  sha256 "ff783eb21adf9eda48fde60a06ee7bbb3af174427cb084e197b2a890615146b3"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9563ba7970bdb736f8f02519e5bc8d351899ea9e0bd07bec691d063e6ad96843"
    sha256 cellar: :any,                 arm64_monterey: "ec1bd76d6f36ece9f3fff2c5d9d5b6a35f26dac065279cc07be56a232ffe025f"
    sha256 cellar: :any,                 arm64_big_sur:  "4157dc5bda02b6c7e5d666108b2eb0d16166fefec52ee88d01670dcadcd91205"
    sha256 cellar: :any,                 ventura:        "8d54f8f5ef249ae5c7631442bb8a0df08663f565c4e5f52d9517c16b98199efe"
    sha256 cellar: :any,                 monterey:       "930adcf5ea795250b4ee9362cc497345ae76e10aa623d71967f1aecfb654459b"
    sha256 cellar: :any,                 big_sur:        "ddc547ffb114f3f0b9ec2a1f9c44fd8306cdbb87c933e9c31d81db2e1f3581e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2341abbca029463574ef183fd4ad6f399e28c23cdd0a8be091ae90b1eddd63cf"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    cd "wangle" do
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
      system "make", "clean"
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
      system "make"
      lib.install "lib/libwangle.a"

      pkgshare.install Dir["example/echo/*.cpp"]
    end
  end

  test do
    cxx_flags = %W[
      -std=c++17
      -I#{include}
      -I#{Formula["openssl@1.1"].opt_include}
      -L#{Formula["gflags"].opt_lib}
      -L#{Formula["glog"].opt_lib}
      -L#{Formula["folly"].opt_lib}
      -L#{Formula["fizz"].opt_lib}
      -L#{lib}
      -lgflags
      -lglog
      -lfolly
      -lfizz
      -lwangle
    ]
    if OS.linux?
      cxx_flags << "-L#{Formula["boost"].opt_lib}"
      cxx_flags << "-lboost_context-mt"
      cxx_flags << "-ldl"
      cxx_flags << "-lpthread"
    end

    system ENV.cxx, pkgshare/"EchoClient.cpp", *cxx_flags, "-o", "EchoClient"
    system ENV.cxx, pkgshare/"EchoServer.cpp", *cxx_flags, "-o", "EchoServer"

    port = free_port
    fork { exec testpath/"EchoServer", "-port", port.to_s }
    sleep 10

    require "pty"
    output = ""
    PTY.spawn(testpath/"EchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 20
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end
