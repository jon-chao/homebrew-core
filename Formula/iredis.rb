class Iredis < Formula
  include Language::Python::Virtualenv

  desc "Terminal Client for Redis with AutoCompletion and Syntax Highlighting"
  homepage "https://iredis.io"
  url "https://files.pythonhosted.org/packages/43/2a/9a94d3fb93a5666da5e1fbfeb224d2bd5ae1558e9aac884ca856236432c5/iredis-1.12.0.tar.gz"
  sha256 "c3031094db0aa03d48b6f9be750e32d3e901942a96cc05283029086cb871cd81"
  license "BSD-3-Clause"
  head "https://github.com/laixintao/iredis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2280369fb335c6d5aa2b66cde1a792801d27b88d8e25dad244cc2b4422934c0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acc0941a410754a930a114b82bdad4e164db7cba2e472ca6b2d6b659fd51e301"
    sha256 cellar: :any_skip_relocation, monterey:       "b44f5e27dee871ca46efd273fd9246c46db0bc3d8fc5b7cc6d0ffacf26e09ecb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6141ed321bbe104ace573a9c7fb698020da17bb71aec57ad9bb1687f070f4e1e"
    sha256 cellar: :any_skip_relocation, catalina:       "8581b5e5553e01adde363fe81f0d0021e3c1ffd6c0b8175a1bd96bb4d395a826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98997277d9d7f8d8d40c9030bdad1d77660e14900161828c72fa5f11c12ac5a0"
  end

  depends_on "poetry" => :build
  depends_on "python@3.10"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/a5/66/b844887f2225049abd75a0c54415d419e334b7a7e2a69c5a5c4968e30906/importlib_resources-5.8.0.tar.gz"
    sha256 "568c9f16cb204f9decc8d6d24a572eeea27dacbb4cee9e6b03a8025736769751"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/33/36/506af4690234e7a84b8b3e0f4aee4dfe5a28b8688a0eec2047af9a078020/mistune-2.0.2.tar.gz"
    sha256 "6fc88c3cb49dba8b16687b41725e661cf85784c12e8974a29b9d336dd596c3a1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/db/15/6e89ae7cde7907118769ed3d2481566d05b5fd362724025198bb95faf599/pendulum-2.1.2.tar.gz"
    sha256 "b06a0ca1bfe41c990bbf0c029f0b6501a7f2ec4e38bfec730712015e8860f207"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/59/68/4d80f22e889ea34f20483ae3d4ca3f8d15f15264bcfb75e52b90fb5aefa5/prompt_toolkit-3.0.29.tar.gz"
    sha256 "bd640f60e8cecd74f0dc249713d433ace2ddc62b65ee07f96d358e0b152b6ea7"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytzdata" do
    url "https://files.pythonhosted.org/packages/67/62/4c25435a7c2f9c7aef6800862d6c227fc4cd81e9f0beebc5549a49c8ed53/pytzdata-2020.1.tar.gz"
    sha256 "3efa13b335a00a8de1d345ae41ec78dd11c9f8807f522d39850f2dd828681540"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/b3/17/1e567ff78c83854e16b98694411fe6e08c3426af866ad11397cddceb80d3/redis-3.5.3.tar.gz"
    sha256 "0e7e0cfca8660dea8b7d5cd8c4f6c5e29e11f31158c0b0ae91a397f00e5a05a2"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/25/9d/0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0/wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    # Install pytzdata using brewed poetry to avoid build dependency on Rust.
    resource("pytzdata").stage do
      system Formula["poetry"].opt_bin/"poetry", "build", "--format", "wheel", "--verbose", "--no-interaction"
      venv.pip_install_and_link Dir["dist/pytzdata-*.whl"].first
    end

    venv.pip_install resources.reject { |r| r.name == "pytzdata" }
    venv.pip_install_and_link buildpath
  end

  test do
    port = free_port
    output = shell_output("#{bin}/iredis -p #{port} info 2>&1", 1)
    assert_match "Connection refused", output
  end
end
