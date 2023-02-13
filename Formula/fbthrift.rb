class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2023.02.13.00.tar.gz"
  sha256 "e2aaf9f95682af34ab27c8b88ebb3007919dc8e78765a8ba042839ef91c3c6a9"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1edbdb275a3f1a2fa24396a4db4e3de75a19a09bd5b05aa8af1fdfe2ad7bb21a"
    sha256 cellar: :any,                 arm64_monterey: "1eaa55611fe1d0961fa6ca6e39efdda4ce648c0607a9a982941d27f42857c8d5"
    sha256 cellar: :any,                 arm64_big_sur:  "431a61cd034364d0e262a42a04e32d1040b662e8247c5af4c991cc156a6c5ab3"
    sha256 cellar: :any,                 ventura:        "1b82dde8407a566bf83f30be25a1047ffbd7459404ad97bcc57ce18e61895531"
    sha256 cellar: :any,                 monterey:       "84ea7d8bd2df0abe2915822c5b1c5083345bd8a28d5bf4bb5cde6ae96948c96f"
    sha256 cellar: :any,                 big_sur:        "91593ac5ad1ad9bc31a5c24381768e3c599f4126b025ddf7f21e223687cc0913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8cf58b9dad6c9b77f4f1349f7e08cfad489937760510621251ca25eb4235b9f"
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
