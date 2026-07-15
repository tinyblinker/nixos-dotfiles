{
  xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
    patch:
      ascii_composer:
        switch_key:
          Caps_Lock: noop
      schema_list:
        - schema: rime_ice
      menu/page_size: 8
  '';
  xdg.dataFile."fcitx5/rime/rime_ice.custom.yaml".text = ''
    patch:
      switches:
        - { name: ascii_mode, reset: 0, states: [ 中, Ａ ] }
        - { name: ascii_punct, reset: 0, states: [ ¥, $ ] }
        - { name: traditionalization, reset: 0, states: [ 简, 繁 ] }
        - { name: emoji, reset: 1, states: [ 💀, 😄 ] }
        - { name: full_shape, reset: 0, states: [ 半角, 全角 ] }
        - { name: search_single_char, states: [ 正常, 单字 ], abbrev: [ 词, 单 ] }
  '';
  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Font="Noto Sans CJK SC 13"
    PerScreenDPI=True
  '';
}
