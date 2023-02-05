class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/e4/a9/6704bb5e1d1d778d3a6ee1278a8d8134f0db160e09d52863a24edb58eab5/numpy-1.24.2.tar.gz"
  sha256 "003a9f530e880cb2cd177cba1af7220b9aa42def9c4afc2a2fc3ee6be7eb2b22"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b19a9c333d274fc756fbec8c5a0269cff133b1ec6c5a687667fb26f87dfd027"
    sha256 cellar: :any,                 arm64_monterey: "f8aee27e47bcec38c7e89f15f137e0e5337d6aa84fb8eca1a2435d5a94927234"
    sha256 cellar: :any,                 arm64_big_sur:  "6da6a22f095213214d3a319aed51a84c38ad9d6720368dc54442d70ec5dbc427"
    sha256 cellar: :any,                 ventura:        "548eb4854bb4180736359d827b00575c4b775279aa9d3c0b6a0ed332f078d6d5"
    sha256 cellar: :any,                 monterey:       "ec1d6ef9858e0e0fb54bcbae4d84a38a93324920ea21f7d116822b35eaa6c44b"
    sha256 cellar: :any,                 big_sur:        "95d177a0fdec5a7df287a501397beaa1a1979095fda488bb0fec837290db9c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "668843a8ef5ea954214f77211221c419ebdb13c1291a6b83fa73b0c8220b069d"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "libcython" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "openblas"

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version) # so that `bin/f2py` and `bin/f2py3` use python3.10
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    openblas = Formula["openblas"]
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = openblas.opt_lib/shared_library("libopenblas")

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas.opt_lib}
      include_dirs = #{openblas.opt_include}
    EOS

    Pathname("site.cfg").write config

    pythons.each do |python|
      site_packages = Language::Python.site_packages(python)
      ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages

      system python, "setup.py", "build", "--fcompiler=#{Formula["gcc"].opt_bin}/gfortran",
                                          "--parallel=#{ENV.make_jobs}"
      system python, *Language::Python.setup_install_args(prefix, python)
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
