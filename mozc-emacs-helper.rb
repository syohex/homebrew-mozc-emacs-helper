require "formula"

class MozcEmacsHelper < Formula
  homepage "http://hiroki.jp/homebrew-mozc-emacs-helper"
  url "https://gist.github.com/cef707ac0b23b82f399a.git"
  version "0.0.1"

  def install
    system "rm -rf .git"
    system "git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git"
    system "./depot_tools/gclient config https://github.com/google/mozc.git --name=. --deps-file=src/DEPS"
    system "./depot_tools/gclient sync"
    system "patch src/build_mozc.py < build_mozc.py.patch"
    system "cd src && env GYP_DEFINES='mac_sdk=10.10 mac_deployment_target=10.10' python build_mozc.py gyp --noqt"
    system "cd src && python build_mozc.py build -c Release mac/mac.gyp:GoogleJapaneseInput mac/mac.gyp:gen_launchd_confs unix/emacs/emacs.gyp:mozc_emacs_helper"

    bin.install 'src/out_mac/Release/mozc_emacs_helper'
    system 'sudo cp -r src/out_mac/Release/Mozc.app /Library/Input\ Methods/'
    system 'sudo cp src/out_mac/DerivedSources/Release/mac/org.mozc.inputmethod.Japanese.Converter.plist /Library/LaunchAgents'
    system 'sudo cp src/out_mac/DerivedSources/Release/mac/org.mozc.inputmethod.Japanese.Renderer.plist /Library/LaunchAgents'
  end

  def caveats
    msg = <<-EOF.undent
Please restart your operating system.
EOF
  end
end
