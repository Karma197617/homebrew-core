class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.5/llvm-16.0.5.src.tar.xz"
    sha256 "701b764a182d8ea8fb017b6b5f7f5f1272a29f17c339b838f48de894ffdd4f91"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.5/clang-16.0.5.src.tar.xz"
      sha256 "f4bb3456c415f01e929d96983b851c49d02b595bf4f99edbbfc55626437775a7"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.5/cmake-16.0.5.src.tar.xz"
      sha256 "9400d49acd53a4b8f310de60554a891436db5a19f6f227f99f0de13e4afaaaff"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.5/third-party-16.0.5.src.tar.xz"
      sha256 "0a4bbb8505e95570e529d6b3d5176e93beb3260f061de9001e320d57b59aed59"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a920d59884ecbfd083c39e7cb64679e6e5a87e8ff7f3d25d1207b92ef841c18f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0fff789da92dbc415546ee65478731ac83885f18f746643330b7ee46a799412"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad64c2ff8f28fa2e8301807bf7d1788d06faf4e0dfd72493d42322fef965e1c3"
    sha256 cellar: :any_skip_relocation, ventura:        "26af87da30c304be40198619ec3dc8c2ce42087533a7877634cf4afc250e8976"
    sha256 cellar: :any_skip_relocation, monterey:       "1e73b3a6916a219803431c7a39abf4b826c593685b6fc8595e136faadbafadc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "68cae8c85619fdafb38129bbaae222a619b16098fd0ffbefc324eb410f3ca625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57572acdff0a844546669e0dcd19051cfd39128bac1c496876d0494499c49b0c"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      (buildpath/"src").install buildpath.children
      (buildpath/"src/tools/clang").install resource("clang")
      (buildpath/"cmake").install resource("cmake")
      (buildpath/"third-party").install resource("third-party")

      buildpath/"src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install "build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
