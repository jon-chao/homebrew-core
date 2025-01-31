class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.25.0/deno_src.tar.gz"
  sha256 "6cafe6c40d08f4228030dec96a1b8938fdeadec40cf86774d3ba7410c736eeb6"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc956ad1b414a542fa07316e9eaeaa8e068f8903b10ab7227084f366c82ee023"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39542130919666ee1e44e55a3f2f35dd824e6a0542871ae384b8628b323b3e94"
    sha256 cellar: :any_skip_relocation, monterey:       "537211410ce9ebb83273c968c9b3b4be923ce05555ce198d886a2e045224dd2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "da40a378080e34cf573d41101fcb6429abf2a23eb8b04e6a1b0a3620e34eb92e"
    sha256 cellar: :any_skip_relocation, catalina:       "0454692d3f45ea39afb6f85b409e1fd1ea97026d73386ab23ae042f4b7d2d177"
    sha256                               x86_64_linux:   "17aee7d10996699c3b0d04e11233e5b3a65ac85d928458a6af3ab1c984a5ff3a"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => :build
  depends_on "rust" => :build

  uses_from_macos "xz"

  on_macos do
    depends_on xcode: ["10.0", :build] # required by v8 7.9+
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gcc"
    depends_on "glib"
  end

  fails_with gcc: "5"

  # Temporary resources to work around build failure due to files missing from crate
  # We use the crate as GitHub tarball lacks submodules and this allows us to avoid git overhead.
  # TODO: Remove this and `v8` resource when https://github.com/denoland/rusty_v8/pull/1063 is released
  resource "rusty-v8" do
    url "https://static.crates.io/crates/v8/v8-0.49.0.crate"
    sha256 "5a1cbad73336d67babcbe5e3b03c907c8d2ff77fc6f997570af219bbd9fdb6ce"
  end

  resource "v8" do
    url "https://github.com/denoland/v8/archive/1f7df8c39451f3d53e9acef4b7b0476cf4f5eb66.tar.gz"
    sha256 "5098e515c62e42c0c0754b0daf832f16c081bc53d27b7121bc917fb52759c65a"
  end

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/core/Cargo.toml
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/tree/v#{v8_version}/tools/ninja_gn_binaries.py
  # 3. Find short gn commit hash from commit message: https://github.com/denoland/ninja_gn_binaries/tree/#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https://gn.googlesource.com/gn.git/+/#{gn_commit}
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "bf4e17dc67b2a2007475415e3f9e1d1cf32f6e35"
  end

  # To find the version of tinycc used, check the commit hash referenced from
  # https://github.com/denoland/deno/tree/v#{version}/ext/ffi
  resource "tinycc" do
    url "https://github.com/TinyCC/tinycc.git",
        revision: "afc136262e93ae85fb3643005b36dbfc30d99c42"
  end

  def install
    # Work around files missing from crate
    # TODO: Remove this at the same time as `rusty-v8` + `v8` resources
    (buildpath/"v8").mkpath
    resource("rusty-v8").stage do |r|
      system "tar", "--strip-components", "1", "-xzvf", "v8-#{r.version}.crate", "-C", buildpath/"v8"
    end
    resource("v8").stage do
      cp_r "tools/builtins-pgo", buildpath/"v8/v8/tools/builtins-pgo"
    end
    inreplace %w[core/Cargo.toml serde_v8/Cargo.toml],
              /^v8 = { version = ("[\d.]+"),.*}$/,
              "v8 = { version = \\1, path = \"../v8\" }"

    if OS.mac? && (MacOS.version < :mojave)
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version
    end

    # env args for building a release build with our python3, ninja and gn
    ENV.prepend_path "PATH", Formula["python@3.10"].libexec/"bin"
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3"
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system "python3", "build/gen.py"
      system "ninja", "-C", "out"
    end

    resource("tinycc").stage buildpath/"tinycc"
    cd "tinycc" do
      ENV.append_to_cflags "-fPIE" if OS.linux?
      system "./configure", "--cc=#{ENV.cc}"
      system "make"
    end

    ENV["TCC_PATH"] = buildpath/"tinycc"

    # cargo seems to build rusty_v8 twice in parallel, which causes problems,
    # hence the need for -j1
    # Issue ref: https://github.com/denoland/deno/issues/9244
    system "cargo", "install", "-vv", "-j1", *std_cargo_args(path: "cli")

    bash_output = Utils.safe_popen_read(bin/"deno", "completions", "bash")
    (bash_completion/"deno").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"deno", "completions", "zsh")
    (zsh_completion/"_deno").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"deno", "completions", "fish")
    (fish_completion/"deno.fish").write fish_output
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "console.log",
      shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std@0.50.0/examples/cat.ts " \
                   "#{testpath}/hello.ts")
  end
end
