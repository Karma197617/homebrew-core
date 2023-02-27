class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.02.27.00.tar.gz"
  sha256 "735cb2d078aa76fdecfcc6fa664fdf702665d95f8a081033bce7ef7de5e4de37"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "18090d7a57198bf8bbc6358f1ec8f960617272d256a676cd5a681c48a759d419"
    sha256 cellar: :any,                 arm64_monterey: "aa99442c3174f5ceab9cf009e742b5d901c600e95e96a1209f32755f0911208c"
    sha256 cellar: :any,                 arm64_big_sur:  "92256b3170ee2a5d78f8865272027a6a6e3206472b8687be220a3d2a78272204"
    sha256 cellar: :any,                 ventura:        "bce04ae82000c52808e40d6e2d418737ce60189a25511586e07925814eee4909"
    sha256 cellar: :any,                 monterey:       "38f47a5e794e3efdf070d957db18842b47dd4f282dc28ef939c02686a7862454"
    sha256 cellar: :any,                 big_sur:        "fe977cd7b414934b592af2ef7cb78ec744da5ed6754961a984c050a43cce3508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f49f7df68de95bc303683c1a7f5972791a000973b83aad6c303c811c5aafdf50"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: 'asm goto' constructs are not supported yet
    EOS
  end

  fails_with gcc: "5" # C++ 17

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, *shared_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"
  end

  test do
    (testpath/"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin/"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath/"gen-cpp2", :exist?
    assert_predicate testpath/"gen-cpp2", :directory?
  end
end
