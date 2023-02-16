class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.2",
      revision: "9b77c2c135c228c2eedc310f6e975bb1a76169b1"
  # Outside of the "x-pack" folder, source code in a given file is licensed
  # under the Apache License Version 2.0
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19feacac0afff6462464cd8f1f8f0efc9a7461f5f534a3adc214db01732646e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e68e86b5597a1c6c10799d3c4bd5d28d5157b046892f05299f2cfdd569439cc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23cdf025c04a1d935dc5cf9cea7d93ebec96e46df31455b814313317a6bc7505"
    sha256 cellar: :any_skip_relocation, ventura:        "c5b5b8245e7de52d7cc6d5a52cc3580e71bf575e51c825a18058b8daaa11d6ce"
    sha256 cellar: :any_skip_relocation, monterey:       "707ace2562be1e857d5900f0c219b55b997ab7c0decad1640376baacc56ff591"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5a51c54121f5792cf03d89a7363e5f89237c1c1cf2733745ab3b7559b2f010e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3a656a94ff2bf08075e2b27764d7e56f61e7ab3fd9816d33ff64511d0684e70"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

  uses_from_macos "rsync" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "filebeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.SerialDeps(Fields, Dashboards, Config, includeList, fieldDocs,",
                               "mg.SerialDeps(Fields, Dashboards, Config, includeList,"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc/"filebeat").install Dir["filebeat.*", "fields.yml", "modules.d"]
      (etc/"filebeat"/"module").install Dir["build/package/modules/*"]
      (libexec/"bin").install "filebeat"
      prefix.install "build/kibana"
    end

    (bin/"filebeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/filebeat \
        --path.config #{etc}/filebeat \
        --path.data #{var}/lib/filebeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/filebeat \
        "$@"
    EOS

    chmod 0555, bin/"filebeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"filebeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"filebeat"
  end

  test do
    log_file = testpath/"test.log"
    touch log_file

    (testpath/"filebeat.yml").write <<~EOS
      filebeat:
        inputs:
          -
            paths:
              - #{log_file}
            scan_frequency: 0.1s
      output:
        file:
          path: #{testpath}
    EOS

    (testpath/"log").mkpath
    (testpath/"data").mkpath

    fork do
      exec "#{bin}/filebeat", "-c", "#{testpath}/filebeat.yml",
           "-path.config", "#{testpath}/filebeat",
           "-path.home=#{testpath}",
           "-path.logs", "#{testpath}/log",
           "-path.data", testpath
    end

    sleep 1
    log_file.append_lines "foo bar baz"
    sleep 5

    assert_predicate testpath/"meta.json", :exist?
    assert_predicate testpath/"registry/filebeat", :exist?
  end
end
