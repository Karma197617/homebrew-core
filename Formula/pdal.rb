class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.5.2/PDAL-2.5.2-src.tar.gz"
  sha256 "3966620cbe48c464d70fd5d43fff25596a16abe94abd27d3f48d079fa1ef1f39"
  license "BSD-3-Clause"
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  # The upstream GitHub repository sometimes creates tags that only include a
  # major/minor version (`1.2`) and then uses major/minor/patch (`1.2.0`) for
  # the release tarball. This inconsistency can be a problem if we need to
  # substitute the version from livecheck in the `stable` URL, so we check the
  # first-party download page, which links to the tarballs on GitHub.
  livecheck do
    url "https://pdal.io/en/latest/download.html"
    regex(/href=.*?PDAL[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "0fcae423bf1948c7d87d7c10bcfc7c163b33a24052e5d7658947e8f59aede8e1"
    sha256                               arm64_monterey: "153f751482e3eb3a7f6843f948ace993841e3b5ed9d893007a8b8bb2e7c046c7"
    sha256                               arm64_big_sur:  "dc190d2b8ec5b7ba6b25a40376a118076673660c606ca40c7c63b070cea739c8"
    sha256                               ventura:        "3950233d6a9a9c04c1853d76ab2fdf4df2db7a69eeb2cf8fac10e6d98fd23474"
    sha256                               monterey:       "2ad2b5e91d3054429d7e475d50158e89148b06124decbdda65e91fcf011903f6"
    sha256                               big_sur:        "0f39bbac6c839f8c8a3c282aaa86c5f5928162e1393d464c5219e7d4eb08c23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "060664f801ff90d2f1a4e5b223ea24f5767b75d246aae418f3d92afbf4698795"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libpq"
  depends_on "numpy"

  fails_with gcc: "5" # gdal is compiled with GCC

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DWITH_LASZIP=TRUE",
                         "-DBUILD_PLUGIN_GREYHOUND=ON",
                         "-DBUILD_PLUGIN_ICEBRIDGE=ON",
                         "-DBUILD_PLUGIN_PGPOINTCLOUD=ON",
                         "-DBUILD_PLUGIN_PYTHON=ON",
                         "-DBUILD_PLUGIN_SQLITE=ON"

    system "make", "install"
    rm_rf "test/unit"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
  end
end
