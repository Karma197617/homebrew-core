class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "a84b8441e09643ce4c69fa77cc643aff553b9d87aaffec66b1601e5facb63360"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dc7d6e3f25c76b31c008eb6db18dbaf529983953ebe251251a84c7e8f3b98ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a541f578b05ca56fa9d5eac6114a45fc6b7bf8e9a030ae4e6782bac572f8eff5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf2cf4187226f80799490ea3952b7b9cfff2642cafc029cd58344d0823b792fc"
    sha256 cellar: :any_skip_relocation, ventura:        "f439dedfb9d73635979c202c3243366c1a028dd5c7751bce55fa6b2f94bfc0ba"
    sha256 cellar: :any_skip_relocation, monterey:       "6dfc559da88f30cf4bfca78133fdb73b2b34aa08e0f78c64a7727f0b0e8f2027"
    sha256 cellar: :any_skip_relocation, big_sur:        "7856d75a6b366fcc33922901990735fe7249a355baf0d003ddb355d6cac374e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4613f4a715535e37ba38e3654ecde3bb54e4e2590c0ece68277f722e76ddfd7"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      line.include?("Initialized status surfacer")
    end
  end
end
