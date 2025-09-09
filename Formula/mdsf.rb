class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf?tab=readme-ov-file"
  version "0.10.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/mdsf/releases/download/v0.10.7/mdsf-aarch64-apple-darwin.tar.gz"
      sha256 "692a88740feab91f81893c10e191e1446fc2fe8786bc604ab6793ba3ae0620d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/mdsf/releases/download/v0.10.7/mdsf-x86_64-apple-darwin.tar.gz"
      sha256 "7cc2cf6c3cc3cd3768e8747f62403e850d2ddc7fa49ec969c847f1c11203923d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hougesen/mdsf/releases/download/v0.10.7/mdsf-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "2a2ee88a766fd01f2af68eaa6ff70b8f6c271ba947728eae1cd58db538dc5282"
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
