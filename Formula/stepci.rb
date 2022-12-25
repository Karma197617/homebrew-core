require "language/node"

class Stepci < Formula
  desc "API Testing and Monitoring made simple"
  homepage "https://stepci.com"
  url "https://registry.npmjs.org/stepci/-/stepci-2.6.0.tgz"
  sha256 "e30ffbac5205ace4aa4bd6dd07a7e659a068c4d7c38255ca0faf3d7eb4b2bdec"
  license "MPL-2.0"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://docs.stepci.com/legal/privacy.html
    ENV["STEPCI_DISABLE_ANALYTICS"] = "1"

    (testpath/"workflow.yml").write <<~EOS
      version: "1.1"
      name: Status Check
      env:
        host: example.com
      tests:
        example:
          steps:
            - name: GET request
              http:
                url: https://${{env.host}}
                method: GET
                check:
                  status: /^20/
    EOS

    expected = <<~EOS
      PASS  example

      Tests: 0 failed, 1 passed, 1 total
      Steps: 0 failed, 0 skipped, 1 passed, 1 total
    EOS
    assert_match expected, shell_output("#{bin}/stepci run workflow.yml")

    assert_match version.to_s, shell_output("#{bin}/stepci --version")
  end
end
