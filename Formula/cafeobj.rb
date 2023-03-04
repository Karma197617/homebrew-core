class Cafeobj < Formula
  desc "New generation algebraic specification and programming language"
  homepage "https://cafeobj.org/"
  url "https://github.com/CafeOBJ/cafeobj/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "12780724a2b63ee45b12b79fd574ea1dc2870b59a4964ae51d9acc47dbbcff3d"
  license all_of: [
    "BSD-2-Clause",
    :public_domain, # comlib/let-over-lambda.lisp
    "MIT", # asdf.lisp
  ]
  head "https://github.com/CafeOBJ/cafeobj.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "10246511909bb1842e63381af4dc8adc87fdeae9eb5e926c5bc130ff3629e862"
    sha256 arm64_monterey: "d338e4868d48d4f244ff91c745de7d0fa6adf41825eb9bde53e371e01960381c"
    sha256 arm64_big_sur:  "1912508b031a0b0e098c3195a044d0a2f4988d8906bdc2c5cfae1c98e508f59a"
    sha256 ventura:        "a9a26d895a3a955b67bdd7b712592a20eb566eb850cff7b7c2de4dd5258f933f"
    sha256 big_sur:        "724109123713a037126847a07fe06e4fa134d3e28aff72ae72de7f8f4fa77576"
    sha256 catalina:       "7e5281633b3f18239282905a748c61b702b2d059daf559fd52187aa6d079e79c"
    sha256 mojave:         "1a875e6c86c2d15862f0b64ee9bb90077bff62748d3c2d91f201527ea78886ac"
  end

  depends_on "sbcl"

  def install
    system "./configure", "--with-lisp=sbcl", "--prefix=#{prefix}", "--with-lispdir=#{share}/emacs/site-lisp/cafeobj"
    system "make", "install"
  end

  test do
    system "#{bin}/cafeobj", "-batch"
  end
end
