class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.5.0/polynote-dist.tar.gz"
  sha256 "173feb74da99c87e7b658b6f5a6400b0ee8a7da9a5975cde196a3285f471e152"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "8cfb10752dbbdf07ea6dd55a6f2a3b4cbf63e7ae2e9d075d7ac5bca1889eb233"
    sha256 cellar: :any, arm64_monterey: "17bfeb81e5a1622f2717953db56d43dc14bad82049ca226dedcf1b408fd5b6bf"
    sha256 cellar: :any, arm64_big_sur:  "4aacdc01c58ab424ad45c801be76380f4cb5a4881944cc4504889dea0d8a773d"
    sha256 cellar: :any, ventura:        "e88ffafee90af291e739394af8c6e706822097832900734f3781542edf669155"
    sha256 cellar: :any, monterey:       "ecbe7dd1f51869ef7a007eccfc7c313d21284dc5c0a865eb0618207c9eaddc7f"
    sha256 cellar: :any, big_sur:        "afd1808f167bb3e3c21feab17924611a743abbc947a1780d46f57c006a0caf66"
    sha256               x86_64_linux:   "afb48cc127304977afb6b5a8280816cd19b4729a6fe1648033cb7bc436b8e56a"
  end

  depends_on "numpy" # used by `jep` for Java primitive arrays
  depends_on "openjdk"
  depends_on "python@3.11"

  resource "jep" do
    url "https://files.pythonhosted.org/packages/b3/0c/d208bc8a86f032b9a9270876129aadb41fa1a4baa172d68a29c579950856/jep-4.1.1.tar.gz"
    sha256 "5914a4d815a7e86819f55be3de840edc2d3fe0d0b3f67626e5cea73841b1d1c0"
  end

  def install
    python3 = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python3)

    with_env(JAVA_HOME: Language::Java.java_home) do
      resource("jep").stage do
        # Help native shared library in jep resource find libjvm.so on Linux.
        unless OS.mac?
          ENV.append "LDFLAGS", "-L#{Formula["openjdk"].libexec}/lib/server"
          ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["openjdk"].libexec}/lib/server"
        end

        system python3, *Language::Python.setup_install_args(libexec/"vendor", python3)
      end
    end

    libexec.install Dir["*"]
    rewrite_shebang detected_python_shebang, libexec/"polynote.py"

    env = Language::Java.overridable_java_home_env
    env["PYTHONPATH"] = ENV["PYTHONPATH"]
    (bin/"polynote").write_env_script libexec/"polynote.py", env
  end

  test do
    mkdir testpath/"notebooks"

    assert_predicate bin/"polynote", :exist?
    assert_predicate bin/"polynote", :executable?

    output = shell_output("#{bin}/polynote version 2>&1", 1)
    assert_match "Unknown command version", output

    port = free_port
    (testpath/"config.yml").write <<~EOS
      listen:
        host: 127.0.0.1
        port: #{port}
      storage:
        dir: #{testpath}/notebooks
    EOS

    begin
      pid = fork do
        exec bin/"polynote", "--config", "#{testpath}/config.yml"
      end
      sleep 5

      assert_match "<title>Polynote</title>", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
