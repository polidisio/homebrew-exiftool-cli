class ExiftoolCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for extracting, exporting, and removing EXIF metadata from photos"
  homepage "https://github.com/polidisio/exiftool-cli"
  license "MIT"
  head "https://github.com/polidisio/exiftool-cli.git", branch: "main"

  depends_on "python@3.11"

  def install
    virtualenv_created_with_system_python = false

    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install "Pillow>=10.0.0", "piexif>=1.1.3", "click>=8.1.0", "colorama>=0.4.6"
    venv.pip_install_and_link buildpath

    bin.install_symlink "#{libexec}/bin/exiftool-cli" => "exiftool-cli"
  end

  test do
    system "#{bin}/exiftool-cli", "--help"
  end
end
