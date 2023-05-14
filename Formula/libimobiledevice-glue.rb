class LibimobiledeviceGlue < Formula
  desc "Library with common system API code for libimobiledevice projects"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice-glue/releases/download/1.0.0/libimobiledevice-glue-1.0.0.tar.bz2"
  sha256 "160a70e2edc318312fc40b6a71f85bfdfabdfba10bcfc5bb6fb40ed95088f4a0"
  license "LGPL-2.1-or-later"

  depends_on "pkg-config" => :build
  depends_on "libplist"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "libimobiledevice-glue/utils.h"

      int main(int argc, char* argv[]) {
        char *uuid = generate_uuid();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-limobiledevice-glue-1.0", "-o", "test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
