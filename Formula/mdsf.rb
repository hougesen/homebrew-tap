class Mdsf < Formula
  desc "Format markdown code snippets using your favorite code formatters"
  homepage "https://github.com/hougesen/mdsf"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/mdsf/releases/download/v0.2.3/mdsf-aarch64-apple-darwin.tar.gz"
      sha256 "e002a6f997de0b43a21a44ac83738dc55cca75452606ff4e602fde8df8368b35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/mdsf/releases/download/v0.2.3/mdsf-x86_64-apple-darwin.tar.gz"
      sha256 "22c11c2d7839fc2b145a034737145db97e0ae3d8dde04e957c30bb2b7682bb70"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hougesen/mdsf/releases/download/v0.2.3/mdsf-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "34dc5ffc6830320b06228009e862292ded2f67df5cf846d7d2b9a6033bf84e61"
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
