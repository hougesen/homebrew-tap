class Hitt < Formula
  desc "command line HTTP testing tool focused on speed and simplicity"
  homepage "https://hitt.mhouge.dk"
  version "0.0.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/hitt/releases/download/v0.0.12/hitt-aarch64-apple-darwin.tar.gz"
      sha256 "4f66265af171b0d83ba11c2511d9b1571d5c3f083114b74b69449fd737cf4d39"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/hitt/releases/download/v0.0.12/hitt-x86_64-apple-darwin.tar.gz"
      sha256 "eeb9a75511bfd7f17880604d728968930dbf07342208139d7b721c82900f50e5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hougesen/hitt/releases/download/v0.0.12/hitt-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "5e9c617049ae9698429138b64a8c4a1767c7d9ceaa91731059d883791197c15c"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
