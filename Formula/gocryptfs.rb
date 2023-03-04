class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.3.1/gocryptfs_v2.3.1_src-deps.tar.gz"
  sha256 "62a856a9771307b34a75a1e9ab9489abe4a4e7e7f9230c2b1046ca037ea2ba50"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f384f63c39b0ce1fabb815e8efb6a14f06cd75d051b7f62ef041058a13fdd369"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

  def install
    system "./build.bash"
    bin.install "gocryptfs", "gocryptfs-xray/gocryptfs-xray"
    man1.install "Documentation/gocryptfs.1", "Documentation/gocryptfs-xray.1"
  end

  test do
    (testpath/"encdir").mkpath
    pipe_output("#{bin}/gocryptfs -init #{testpath}/encdir", "password", 0)
    assert_predicate testpath/"encdir/gocryptfs.conf", :exist?
  end
end
