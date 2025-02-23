class Hitt < Formula
  desc "command line HTTP testing tool focused on speed and simplicity"
  homepage "https://hitt.mhouge.dk"
  version "0.0.18"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/hitt/releases/download/v0.0.18/hitt-aarch64-apple-darwin.tar.gz"
      sha256 "8c0ef278a85b742ed804a43f37fad5215f7fe2ad1fa7c40bed46d0ca32c0aefe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/hitt/releases/download/v0.0.18/hitt-x86_64-apple-darwin.tar.gz"
      sha256 "908343773e8b6310af9dbe5640087f8e246baa12a98f9afa18867342d94d7ead"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hougesen/hitt/releases/download/v0.0.18/hitt-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "590829a6c319d6299d6b6c1d4cf9e64b89bae701ac289ef3cf83d4942cf9c41d"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "hitt" if OS.mac? && Hardware::CPU.arm?
    bin.install "hitt" if OS.mac? && Hardware::CPU.intel?
    bin.install "hitt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
