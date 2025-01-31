class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.54.7.tgz"
  sha256 "b261d854cbb84fad6f2d2b0fb6ab558658cfd2d6d0c483d71e1b0a7a897f696d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41e8c22e48232f757b7a895fa76d3b1975f5256d097ea728a94c57093848dc79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41e8c22e48232f757b7a895fa76d3b1975f5256d097ea728a94c57093848dc79"
    sha256 cellar: :any_skip_relocation, monterey:       "41e8c22e48232f757b7a895fa76d3b1975f5256d097ea728a94c57093848dc79"
    sha256 cellar: :any_skip_relocation, big_sur:        "41e8c22e48232f757b7a895fa76d3b1975f5256d097ea728a94c57093848dc79"
    sha256 cellar: :any_skip_relocation, catalina:       "41e8c22e48232f757b7a895fa76d3b1975f5256d097ea728a94c57093848dc79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2102a6dab25ff20334a016a43b3ebe9b1cce55351acc867aeacd374415f8f3a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
