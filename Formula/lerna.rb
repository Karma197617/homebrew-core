require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-6.2.0.tgz"
  sha256 "540216da5b4e85e3825091262d4dba4dee2d37965a8ee966af76249651e2d79e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "848bd852dff3144fbb64e86d2360e7fdf48956cad43d2db8f6ab07a2ec32cbf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c83fd1b45bedae4abee157231b5fe78331ac14948e3e99c183a71eda10ce4d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c83fd1b45bedae4abee157231b5fe78331ac14948e3e99c183a71eda10ce4d0"
    sha256 cellar: :any_skip_relocation, ventura:        "e543b304f8cae65e7910c34ad9199b350a0fc4b47be6ce062e9402abde4f4d0c"
    sha256 cellar: :any_skip_relocation, monterey:       "a6c8f333fd0d643184f63379826daf456f29566fd754393fd3330837abf93d6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6c8f333fd0d643184f63379826daf456f29566fd754393fd3330837abf93d6a"
    sha256 cellar: :any_skip_relocation, catalina:       "a6c8f333fd0d643184f63379826daf456f29566fd754393fd3330837abf93d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c83fd1b45bedae4abee157231b5fe78331ac14948e3e99c183a71eda10ce4d0"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/lerna/node_modules"
    (node_modules/"@parcel/watcher/prebuilds/linux-x64/node.napi.musl.node").unlink
    (node_modules/"@parcel/watcher/prebuilds").each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
