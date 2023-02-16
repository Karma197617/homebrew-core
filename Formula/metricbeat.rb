class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.2",
      revision: "9b77c2c135c228c2eedc310f6e975bb1a76169b1"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d744af7c60a7fe84cbc506e7ea638417febce1d15336802ab0f736f09737653"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1af83ecdfc6cd1eb43366d70a81c6add80a5a5dd68b6bb78f6b0caac1468c8d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68e8f3d97c6299ce9fa57dab4ea51abd3f7aa7b912171cce8b8b1c3126b3a184"
    sha256 cellar: :any_skip_relocation, ventura:        "450d4c9403b1020e1820965ba70bdfae2983358fbf946d19f2bf8d584c1a2192"
    sha256 cellar: :any_skip_relocation, monterey:       "8d51bb6ab5375d535c586c8f268e021936844eaf6771a7d2b143cd1dad705346"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9e9907d71232aace6c4a61db93821313b63f1b2d106627b2946131d869e4e62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b1ab7dd95144ef5917feb6ea1951a59deeb37dab28e9141c9928eb818377a58"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"metricbeat").install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    EOS

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~EOS
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    EOS

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    fork do
      exec bin/"metricbeat", "-path.config", testpath/"config", "-path.data",
                             testpath/"data"
    end

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  end
end
