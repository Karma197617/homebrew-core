class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.2",
      revision: "9b77c2c135c228c2eedc310f6e975bb1a76169b1"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "843d012e5a998a3cb06e4baa607f9c3e2eaeab5e58dd544b338f2d21aac9d4ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a258107b0228692dd8a5243d3c588f822dfe6a39fb648add9c7ac3f76d7b814"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74fff406c0dc2a971f0d06f9ca492dfc6f73e443a393bd4d59c4cd72932f8670"
    sha256 cellar: :any_skip_relocation, ventura:        "b629563acc7de6f00562f7306d77c43740b3ababef2c91ab5ae0812ee7e7d020"
    sha256 cellar: :any_skip_relocation, monterey:       "b09e4a0e7f8232e8761f4175e413fef482b80b0a83f60280ca880a7cd2c87995"
    sha256 cellar: :any_skip_relocation, big_sur:        "c16d1d4f79a7622ca66f582a7659e4f2f7008bb8c1b086b7006d6947412588e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b3a30403da57323bded3bcdae630f3e4cb63ac6662ca041cd054e5cf9dc752a"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "packetbeat" do
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      (etc/"packetbeat").install Dir["packetbeat.*", "fields.yml"]
      (libexec/"bin").install "packetbeat"
      prefix.install "_meta/kibana"
    end

    (bin/"packetbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/packetbeat \
        --path.config #{etc}/packetbeat \
        --path.data #{var}/lib/packetbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/packetbeat \
        "$@"
    EOS

    chmod 0555, bin/"packetbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"packetbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"packetbeat"
  end

  test do
    eth = if OS.mac?
      "en"
    else
      "eth"
    end
    assert_match "0: #{eth}0", shell_output("#{bin}/packetbeat devices")
    assert_match version.to_s, shell_output("#{bin}/packetbeat version")
  end
end
