require "formula"

class MozcEmacsHelper < Formula
  homepage "http://hiroki.jp/homebrew-mozc-emacs-helper"
  url "https://gist.github.com/cef707ac0b23b82f399a.git"
  version "0.0.1"

  def install
    system "git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git"
    system "./depot_tools/gclient config https://github.com/google/mozc.git"
    system "./depot_tools/gclient sync"
    system "cd mozc && patch src/build_mozc.py < build_mozc.py.patch"
    system "cd mozc && python src/build_mozc.py gyp --noqt"
    system "cd mozc && python src/build_mozc.py build -c Release src/mac/mac.gyp:GoogleJapaneseInput src/mac/mac.gyp:gen_launchd_confs src/unix/emacs/emacs.gyp:mozc_emacs_helper"

    bin.install 'mozc/src/out_mac/Release/mozc_emacs_helper'
    system 'sudo cp -r mozc/src/out_mac/Release/Mozc.app /Library/Input\ Methods/'
    system 'sudo cp mozc/src/out_mac/DerivedSources/Release/mac/org.mozc.inputmethod.Japanese.Converter.plist /Library/LaunchAgents'
    system 'sudo cp mozc/src/out_mac/DerivedSources/Release/mac/org.mozc.inputmethod.Japanese.Renderer.plist /Library/LaunchAgents'
  end

  def caveats
    msg = <<-EOF.undent
Please restart your operating system.
EOF
  end
end
