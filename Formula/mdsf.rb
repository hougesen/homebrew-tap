class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/mdsf/releases/download/v0.8.1/mdsf-aarch64-apple-darwin.tar.gz"
      sha256 "7836a8d8dd827503d6bc4462714ab8a77476bfeb4d622302a0036d93327ce1f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/mdsf/releases/download/v0.8.1/mdsf-x86_64-apple-darwin.tar.gz"
      sha256 "36b00741ff2d3ff170a35f8ff594df67a256efb84cad7d46bf643d08ba791fd8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hougesen/mdsf/releases/download/v0.8.1/mdsf-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "e3bbbe07db5fdcc00420055f46553bfc0c05f469334141b026b5fe088b47c695"
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
