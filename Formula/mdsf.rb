class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf?tab=readme-ov-file"
  version "0.10.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/mdsf/releases/download/v0.10.8/mdsf-aarch64-apple-darwin.tar.gz"
      sha256 "8a1cb6b5c81c6fd2953752be287a47d54999ddb6318ccbc8cd8d96f771bc7dad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/mdsf/releases/download/v0.10.8/mdsf-x86_64-apple-darwin.tar.gz"
      sha256 "f5a1ca0749f039fde8bbd181fd6d65c6fa1ff74a6558d9c89d47ce6010ce7e65"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hougesen/mdsf/releases/download/v0.10.8/mdsf-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "2e0eeb55bdd74990003f34089eaed82abc10c6eca9ee833830e23a6c331be47d"
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
