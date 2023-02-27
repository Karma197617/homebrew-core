class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.02.27.00/wangle-v2023.02.27.00.tar.gz"
  sha256 "037db6cdcbdd1c5ba1613f7ee27e04a61dcce1b19163b64d0150fc5232761c58"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0c87993e21d29df43f48ca2af557251cd07ab9a2a881f783de3a044c9d325f04"
    sha256 cellar: :any,                 arm64_monterey: "aee74ca516f8e71b2d3c0103c70418340f6107c8834497cb5576d8f04d61a383"
    sha256 cellar: :any,                 arm64_big_sur:  "c340d97f34048ff195486edbc5357b588aa92205a6218edbeab4dff379da8e81"
    sha256 cellar: :any,                 ventura:        "c37d3cc6352b67e86f5081d38bc45e506f0eeae31ecb3c7466b8fe8324fe0fa2"
    sha256 cellar: :any,                 monterey:       "46be010f2ab83a1dc654babf949edffebf854a846c53827e72a1a3a86d0aeffe"
    sha256 cellar: :any,                 big_sur:        "950d02bb0953a2f1a32f7fbfa27cccae9bb6c7be32ef685471705df7f8ad7720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b33bb2b54abc1696870037a6dce4b2193d130843f433b739c3d70ab292e17da"
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
