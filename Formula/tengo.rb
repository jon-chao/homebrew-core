class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.12.2.tar.gz"
  sha256 "aae5ffbf4a407ed2dee45de10191c095b5d7991af3971bfe937f69fd75085b20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7377f9cb1f6524fcd052a62173e79354ba51c6c1ceb83ceafe2279ce3cc2a653"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7377f9cb1f6524fcd052a62173e79354ba51c6c1ceb83ceafe2279ce3cc2a653"
    sha256 cellar: :any_skip_relocation, monterey:       "26ce101b0a56d218818e96be4224b362add6f37abdc4bdf1dd3381e5bc9ae8be"
    sha256 cellar: :any_skip_relocation, big_sur:        "26ce101b0a56d218818e96be4224b362add6f37abdc4bdf1dd3381e5bc9ae8be"
    sha256 cellar: :any_skip_relocation, catalina:       "26ce101b0a56d218818e96be4224b362add6f37abdc4bdf1dd3381e5bc9ae8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ef701c42ede4cb8f9fdef985822e2c93db54f07ced458cbc67de62df7a331c8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tengo"
  end

  test do
    (testpath/"main.tengo").write <<~EOS
      fmt := import("fmt")

      each := func(seq, fn) {
          for x in seq { fn(x) }
      }

      sum := func(init, seq) {
          each(seq, func(x) { init += x })
          return init
      }

      fmt.println(sum(0, [1, 2, 3]))   // "6"
      fmt.println(sum("", [1, 2, 3]))  // "123"
    EOS
    assert_equal shell_output("#{bin}/tengo #{testpath}/main.tengo"), "6\n123\n"
  end
end
