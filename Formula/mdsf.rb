class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/mdsf/releases/download/v0.8.3/mdsf-aarch64-apple-darwin.tar.gz"
      sha256 "d23b37e3df34f1771dc16213dbfecd45fd16149194662a69f4d1a4045888a869"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/mdsf/releases/download/v0.8.3/mdsf-x86_64-apple-darwin.tar.gz"
      sha256 "f1498461166dd09f6c44367116484ba499d166304ba9b973f426148f58fb9fe6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/hougesen/mdsf/releases/download/v0.8.3/mdsf-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "e994f7e457ee396d7e844a36fd69cc249a5845a5141288aeb0224379b1188873"
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
