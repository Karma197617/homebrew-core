class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.3.3/proxsuite-0.3.3.tar.gz"
  sha256 "53c53c47a578f35ac8fdcf6f3af581fa4e732a04e8e2e600a4bc8e9bd7102cc5"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5abe1ed78726c40f66f28af8a1e871b12215cf1677c038de29d68e1617f08e92"
    sha256 cellar: :any,                 arm64_monterey: "695208b94313a73ce6ac98e5679ef675d5575a61d7211d497ef963be2b3d9d8c"
    sha256 cellar: :any,                 arm64_big_sur:  "251b277b48916d2c43bf761bbbccbe60153c13d43251c9af8b5a6ab69835a81f"
    sha256 cellar: :any,                 ventura:        "701ea6a2e63d31e49aad2d1cb4bd38874a2f1b010b0af41ff2f5b0a1c9514c6d"
    sha256 cellar: :any,                 monterey:       "51eabeb178921e4cffcb80e61f105a900f0d8f3c5d01a73b43b180b9b9abf61e"
    sha256 cellar: :any,                 big_sur:        "09909de5e089106e713adcb35deee6d31e75775890ead2e6727601fef06ef2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fa408e5297f336ab48d9cc16410d654baea098ae6f8c97c8054d6f451fa78ed"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "scipy"
  depends_on "simde"

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages

    # simde include dir can be removed after https://github.com/Simple-Robotics/proxsuite/issues/65
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.11"].opt_libexec/"bin/python"}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_PYTHON_INTERFACE=ON",
                    "-DINSTALL_DOCUMENTATION=ON",
                    "-DSimde_INCLUDE_DIR=#{Formula["simde"].opt_prefix/"include"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python_exe = Formula["python@3.11"].opt_libexec/"bin/python"
    system python_exe, "-c", <<~EOS
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    EOS
  end
end
