class Hitt < Formula
  desc "command line HTTP testing tool focused on speed and simplicity"
  homepage "https://hitt.mhouge.dk"
  version "0.0.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/hitt/releases/download/v0.0.17/hitt-aarch64-apple-darwin.tar.gz"
      sha256 "124d60759c7d5609e6a4ad164bc31cb5244af6b66406678c60ce86d42d0071dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/hitt/releases/download/v0.0.17/hitt-x86_64-apple-darwin.tar.gz"
      sha256 "276dce833d1a662249ad1f7b1b49110f7e0d459c2e033bf2f320f7936523659c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hougesen/hitt/releases/download/v0.0.17/hitt-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "c147e3f72cfa69cc181ddc727e2d2a736d78085fb5865e4adcd9f5d59b52dfbd"
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
