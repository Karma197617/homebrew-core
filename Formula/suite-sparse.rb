class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v7.0.1.tar.gz"
  sha256 "dc2f8d5c2657c120b30cce942f634ec08fc3a4b0b10e19d3eef7790b2bec8d1e"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "Apache-2.0",
    "GPL-3.0-only",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "800547f35ec665c5285aa4b07e84e2397c062e09dccd46e65481e433f442b0de"
    sha256 cellar: :any,                 arm64_monterey: "5686b2ea580a81059913df0d9dd1f8d117b89f583967ea25a2a4f741a6714921"
    sha256 cellar: :any,                 arm64_big_sur:  "88337a211c6c36a234b1e007d696dd97cee549f06b316d3523e1a186bbac2f83"
    sha256 cellar: :any,                 ventura:        "4fd414d62bc14a2737736dfab169c9e5f7a1684766ff1338278e75929aa0b882"
    sha256 cellar: :any,                 monterey:       "44cde4609e04dd354f160735bbaf07e4142dc1ff33295c817bdfef64c2e482a1"
    sha256 cellar: :any,                 big_sur:        "45f684ff114624b410ac9e24a5660c4f9d943697647dd56c97cd2e8ef1ba3160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93309af5befc94e7641a0159f95bef6b087a6399e35516d159356b901af2acae"
  end

  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas"

  uses_from_macos "m4"

  conflicts_with "mongoose", because: "suite-sparse vendors libmongoose.dylib"

  def install
    cmake_args = *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    args = [
      "INSTALL=#{prefix}",
      "BLAS=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "LAPACK=$(BLAS)",
      "MY_METIS_LIB=-L#{Formula["metis"].opt_lib} -lmetis",
      "MY_METIS_INC=#{Formula["metis"].opt_include}",
      "CMAKE_OPTIONS=#{cmake_args.join(" ")}",
      "JOBS=#{ENV.make_jobs}",
    ]

    # Parallelism is managed through the `JOBS` make variable and not with `-j`.
    ENV.deparallelize
    system "make", "library", *args
    system "make", "install", *args
    lib.install Dir["**/*.a"]
    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
           "-L#{lib}", "-lsuitesparseconfig", "-lklu"
    assert_predicate testpath/"test", :exist?
    assert_match "x [0] = 1", shell_output("./test")
  end
end
