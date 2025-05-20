class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf?tab=readme-ov-file"
  version "0.9.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/mdsf/releases/download/v0.9.5/mdsf-aarch64-apple-darwin.tar.gz"
      sha256 "a73c9ba8f7ab60198561cef62240e4e9d88e71812c332d22b68cf55a36470464"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/mdsf/releases/download/v0.9.5/mdsf-x86_64-apple-darwin.tar.gz"
      sha256 "62447b086f78c5fe41f8c7539b8227e2f46c2631812759b93bbc364222d174d0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hougesen/mdsf/releases/download/v0.9.5/mdsf-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "ce739ba1cb8180cbc6ede097e980aac96d8861be38e321606ac0a217a3f4c28c"
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
