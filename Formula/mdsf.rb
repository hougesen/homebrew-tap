class Mdsf < Formula
  desc "Format markdown code snippets using your favorite code formatters"
  homepage "https://github.com/hougesen/mdsf"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/mdsf/releases/download/v0.3.2/mdsf-aarch64-apple-darwin.tar.gz"
      sha256 "92787135f9da8a622f474f57f4b4d91031200ff62a875fe51445b16097bd35a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/mdsf/releases/download/v0.3.2/mdsf-x86_64-apple-darwin.tar.gz"
      sha256 "50bbf53d3e49eafa04d2499c123390bcc8b57cccba5565e47897e9e2c6e40035"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hougesen/mdsf/releases/download/v0.3.2/mdsf-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "9f969be2a39d93d3b828c634fdc579d0e534c0ab1ae4ca2da3df2c1ab27bbbdc"
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
    bin.install "mdsf" if OS.mac? && Hardware::CPU.arm?
    bin.install "mdsf" if OS.mac? && Hardware::CPU.intel?
    bin.install "mdsf" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
