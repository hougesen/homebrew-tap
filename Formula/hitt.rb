class Hitt < Formula
  desc "command line HTTP testing tool focused on speed and simplicity"
  homepage "https://hitt.mhouge.dk"
  version "0.0.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/hitt/releases/download/v0.0.14/hitt-aarch64-apple-darwin.tar.gz"
      sha256 "021a763137d0deae995814cf71102733c693c5446a4e34353c31acf3aa3d8313"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/hitt/releases/download/v0.0.14/hitt-x86_64-apple-darwin.tar.gz"
      sha256 "3fffb07eb9d0f91e9d1af46df8f6ee23e0c79238ad5832177361912f71a8383d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hougesen/hitt/releases/download/v0.0.14/hitt-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "56a91d62e0f06bf427499bd1a9571a1c92b43222563f79dceb9d14eec88bdc93"
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
